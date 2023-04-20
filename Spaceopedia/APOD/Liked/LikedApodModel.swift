//
//  LikedApodModel.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 20/04/23.
//

import Foundation

/// Model object that represents a Liked APOD.
struct LikedApod: Codable
{
    var date: Date
    var apod: Apod
}
