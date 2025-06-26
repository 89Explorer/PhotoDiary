//
//  AIQuestion.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/26/25.
//

import Foundation

struct AIQuestion {
    var question: String
    var answer: String?
    
    static func generateRandomQuestions(count: Int = 5) -> [AIQuestion] {
        let pool = [
            "오늘 있었던 일 중 가장 기억에 남는 순간은 무엇이었나요?",
            "오늘 기분을 색으로 표현한다면 어떤 색인가요?",
            "하루 중 가장 편안했던 순간은 언제였나요?",
            "누군가에게 고마웠던 일이 있었나요?",
            "오늘 나 자신에게 해주고 싶은 말이 있다면?",
            "오늘 처음 해본 일이 있었나요?",
            "오늘 내가 웃었던 이유는 무엇이었나요?",
            "오늘 가장 많이 떠오른 사람은 누구였나요?",
            "오늘의 날씨는 당신에게 어떤 영향을 줬나요?",
            "오늘 들은 말 중에 가장 기억에 남는 건?",
            "오늘 나를 잠시 멈춰 서게 한 생각이 있었나요?",
            "오늘 먹은 것 중 가장 맛있었던 건?",
            "오늘 하루를 동물에 비유한다면 어떤 동물인가요?",
            "오늘 나를 힘들게 했던 순간이 있었나요?",
            "오늘 나를 기분 좋게 만든 사소한 일은?",
            "오늘 하루를 한 문장으로 요약한다면?",
            "오늘 감정의 파도에서 가장 높았던 순간은?",
            "오늘의 나는 어제의 나보다 어떤 점이 달랐나요?",
            "오늘 만난 사람 중 기억에 남는 사람이 있다면?",
            "오늘 하루 중 가장 조용했던 순간은 언제였나요?",
            "무의식적으로 가장 많이 했던 생각은 무엇인가요?"
        ]
        let uniqueShuffled = Array(Set(pool)).shuffled().prefix(count)
        return uniqueShuffled.map { AIQuestion(question: $0, answer: nil) }
    }
}
