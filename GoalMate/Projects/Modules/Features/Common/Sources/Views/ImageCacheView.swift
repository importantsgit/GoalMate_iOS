//
//  ImageCacheView.swift
//  FeatureCommon
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Image Cache
actor ImageCache {
    static let shared = ImageCache()
    private var cache: [String: Image] = [:]

    func insert(_ image: Image, for key: String) {
        cache[key] = image
    }

    func get(for key: String) -> Image? {
        cache[key]
    }

    func remove(for key: String) {
        cache.removeValue(forKey: key)
    }

    func clear() {
        cache.removeAll()
    }
}

// MARK: - Feature
@Reducer
public struct CachedImageFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var imageURL: String
        var image: Image?
        var isLoading: Bool = true
        var error: String?

        public init(url: String) {
            self.imageURL = url
        }
    }

    public enum Action {
        case onAppear
        case imageLoaded(TaskResult<Image>)
        case clearCache
    }

    @Dependency(\.continuousClock) var clock

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [url = state.imageURL] send in
                    if let cached = await ImageCache.shared.get(for: url) {
                        await send(.imageLoaded(.success(cached)))
                        return
                    }
                    do {
                        guard let imageURL = URL(string: url) else {
                            throw URLError(.badURL)
                        }
                        let (data, _) = try await URLSession.shared.data(from: imageURL)
                        guard let uiImage = UIImage(data: data) else {
                            throw URLError(.cannotDecodeContentData)
                        }
                        let image = Image(uiImage: uiImage)
                        await ImageCache.shared.insert(image, for: url)
                        await send(.imageLoaded(.success(image)))
                    } catch {
                        await send(.imageLoaded(.failure(error)))
                    }
                }
            case let .imageLoaded(.success(image)):
                state.isLoading = false
                state.image = image
                state.error = nil
                return .none
            case let .imageLoaded(.failure(error)):
                state.isLoading = false
                state.error = error.localizedDescription
                return .none
            case .clearCache:
                return .run { _ in
                    await ImageCache.shared.clear()
                }
            }
        }
    }
}

// MARK: - View
public struct CachedImageView: View {
    let store: StoreOf<CachedImageFeature>

    public init(url: String) {
        self.store = Store(
            initialState: CachedImageFeature.State.init(url: url)) {
                CachedImageFeature()
            }
    }

    public var body: some View {
        WithPerceptionTracking {
            Group {
                if let image = store.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if store.error != nil {
                    Images.placeholder
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if store.isLoading {
                    ProgressView()
                } else {
                    Colors.grey200
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Colors.grey200)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

// MARK: - Modifier
extension View {
    func clearImageCache() {
        Task {
            await ImageCache.shared.clear()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        CachedImageView(url: "https://picsum.photos/200")
        CachedImageView(url: "https://picsum.photo")
    }
    .frame(width: 200)

}
