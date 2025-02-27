//
//  Comment.swift
//  Data
//
//  Created by 이재훈 on 2/27/25.
//

import Foundation

public struct GetNewCommentsCountsResponseDTO: Codable {
    let newCommentsCount: Int
}

public struct FecthCommentRoomsResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?

    public struct Response: Codable {
        public let commentRooms: [CommentRoom]
        public let page: Page

        enum CodingKeys: String, CodingKey {
            case commentRooms = "comment_rooms"
            case page
        }
    }
}

public struct FetchCommentDetailResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?

    public struct Response: Codable {
        public let comments: [CommentContent]
        public let page: Page
    }
}

public struct PostSendCommentResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: CommentContent
}

// MARK: - CommentRoom
public struct CommentRoom: Codable, Identifiable, Equatable {
    public let id: Int
    public let menteeGoalId: Int
    public let menteeGoalTitle: String?
    public let startDate: String?
    public let endDate: String?
    public let menteeName: String?
    public let mentorName: String?
    public let mentorProfileImage: String?
    public let newCommentsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "comment_room_id"
        case menteeGoalId = "mentee_goal_id"
        case menteeGoalTitle = "mentee_goal_title"
        case startDate = "start_date"
        case endDate = "end_date"
        case menteeName = "mentee_name"
        case mentorName = "mentor_name"
        case mentorProfileImage = "mentor_profile_image"
        case newCommentsCount = "new_comments_count"
    }
}

public struct CommentContent: Codable, Identifiable, Equatable {
    public let id: Int
    public let comment: String?
    public let commentedAt: String?
    public let writer: String?
    public let writerRole: WriterRole?
    public enum CodingKeys: String, CodingKey {
        case id, comment, writer
        case commentedAt = "commented_at"
        case writerRole = "writer_role"
    }
    public enum WriterRole: String, Codable {
        case mentor = "MENTOR"
        case mentee = "MENTEE"
    }
}
