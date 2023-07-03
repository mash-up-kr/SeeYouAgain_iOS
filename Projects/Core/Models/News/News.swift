//
//  News.swift
//  Models
//
//  Created by 안상희 on 2023/07/01.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct News: Equatable, Identifiable {
  public let id: Int
  public let title: String
  public let thumbnailImageUrl: String?
  public let newsLink: String
  public let press: String
  public let writtenDateTime: String
  public let type: String
  public let category: String
  
  public init(
    id: Int,
    title: String,
    thumbnailImageUrl: String?,
    newsLink: String,
    press: String,
    writtenDateTime: String,
    type: String,
    category: String
  ) {
    self.id = id
    self.title = title
    self.thumbnailImageUrl = thumbnailImageUrl
    self.newsLink = newsLink
    self.press = press
    self.writtenDateTime = writtenDateTime
    self.type = type
    self.category = category
  }
}

public extension News {
#if DEBUG
  static let stub = [
    News(
      id: 5549,
      title: "‘86 운동권 출신’ 함운경 민주당에 돌직구…“日 오염수 공세, 반일 선동 의도”",
      thumbnailImageUrl: "https://imgnews.pstatic.net/image/029/2023/06/28/0002809767_001_20230628100501064.jpg?type=w647",
      newsLink: "https://n.news.naver.com/mnews/article/029/0002809767?sid=100",
      press: "디지털타임스1",
      writtenDateTime: "2023.06.28. 오전 10:03",
      type: "NORMAL",
      category: "POLITICS"
    ),
    News(
      id: 5550,
      title: "‘86 운동권 출신’ 함운경 민주당에 돌직구…“日 오염수 공세, 반일 선동 의도”",
      thumbnailImageUrl: "https://imgnews.pstatic.net/image/029/2023/06/28/0002809767_001_20230628100501064.jpg?type=w647",
      newsLink: "https://n.news.naver.com/mnews/article/029/0002809767?sid=100",
      press: "디지털타임스2",
      writtenDateTime: "2023.06.28. 오전 10:03",
      type: "NORMAL",
      category: "POLITICS"
    ),
    News(
      id: 5551,
      title: "‘86 운동권 출신’ 함운경 민주당에 돌직구…“日 오염수 공세, 반일 선동 의도”",
      thumbnailImageUrl: "https://imgnews.pstatic.net/image/029/2023/06/28/0002809767_001_20230628100501064.jpg?type=w647",
      newsLink: "https://n.news.naver.com/mnews/article/029/0002809767?sid=100",
      press: "디지털타임스3",
      writtenDateTime: "2023.06.28. 오전 10:03",
      type: "NORMAL",
      category: "POLITICS"
    ),
    News(
      id: 5552,
      title: "‘86 운동권 출신’ 함운경 민주당에 돌직구…“日 오염수 공세, 반일 선동 의도”",
      thumbnailImageUrl: "https://imgnews.pstatic.net/image/029/2023/06/28/0002809767_001_20230628100501064.jpg?type=w647",
      newsLink: "https://n.news.naver.com/mnews/article/029/0002809767?sid=100",
      press: "디지털타임스4",
      writtenDateTime: "2023.06.28. 오전 10:03",
      type: "NORMAL",
      category: "POLITICS"
    ),
    News(
      id: 5553,
      title: "‘86 운동권 출신’ 함운경 민주당에 돌직구…“日 오염수 공세, 반일 선동 의도”",
      thumbnailImageUrl: "https://imgnews.pstatic.net/image/029/2023/06/28/0002809767_001_20230628100501064.jpg?type=w647",
      newsLink: "https://n.news.naver.com/mnews/article/029/0002809767?sid=100",
      press: "디지털타임스5",
      writtenDateTime: "2023.06.28. 오전 10:03",
      type: "NORMAL",
      category: "POLITICS"
    ),
    News(
      id: 5554,
      title: "‘86 운동권 출신’ 함운경 민주당에 돌직구…“日 오염수 공세, 반일 선동 의도”",
      thumbnailImageUrl: "https://imgnews.pstatic.net/image/029/2023/06/28/0002809767_001_20230628100501064.jpg?type=w647",
      newsLink: "https://n.news.naver.com/mnews/article/029/0002809767?sid=100",
      press: "디지털타임스6",
      writtenDateTime: "2023.06.28. 오전 10:03",
      type: "NORMAL",
      category: "POLITICS"
    )
  ]
#endif
}
