# 🐾 Warala - 와랄라

> **사랑을 기다리는 발자국**  
> 유기동물에게 새로운 가족을 찾아주는 iOS 기반 플랫폼

---

## 소개

Warala(와랄라)는 유기동물 보호소와 사용자를 연결하여, 유기동물에게 따뜻한 관심과 새로운 가족을 찾아주는 플랫폼입니다.  
AI 기반 챗봇, 위치 기반 지도, 사용자 로컬 기록 저장 등 다양한 기능을 통해 동물과 사람 모두에게 편리하고 따뜻한 경험을 제공합니다.


<img width="793" alt="스크린샷 2025-04-15 오후 4 36 42" src="https://github.com/user-attachments/assets/8ee5f7ca-a652-4610-b45a-7dea9f87c884" />

---

## 주요 기능

- 📝 **동물과 함께한 기록 저장**  
  사진과 글을 로컬에 저장하여 따뜻한 기억을 보관할 수 있어요.

- 💌 **유기동물 정보 공유 기능**  
  SNS, 메신저 등을 통해 관심 있는 동물의 정보를 손쉽게 공유하세요.

- 💬 **동물 특성을 반영한 AI 챗봇**  
  OpenAI API를 활용해 동물의 특성에 맞는 정보를 제공하는 챗봇을 지원합니다.

- 🐶 **유기동물 정보 조회 및 관심 등록**  
  보호소 위치, 성별, 특징 등 다양한 정보를 기반으로 유기동물을 조회하고 관심 등록 가능.

- 📍 **위치 기반 보호소/병원 지도**  
  현재 위치를 기반으로 근처의 보호소 및 동물병원을 지도에서 확인할 수 있어요.

<img width="318" alt="스크린샷 2025-04-15 오후 4 37 21" src="https://github.com/user-attachments/assets/9a606141-bb96-4d0b-9c1a-2344095c5291" />
<img width="327" alt="스크린샷 2025-04-15 오후 4 37 40" src="https://github.com/user-attachments/assets/18e23425-59ac-41eb-8fef-000e8f8af14d" />

---

## 🔧 사용 기술 및 라이브러리

| 분류       | 기술/라이브러리 |
|------------|------------------|
| 언어       | Swift            |
| 아키텍처   | MVVM-C, DIContainer, Repository, Router |
| UI         | UIKit, SnapKit, YPImagePicker |
| 지도 기능  | MapKit, CoreLocation |
| 비동기 처리 | RxSwift, RxCocoa, Swift Concurrency |
| 네트워킹   | Alamofire        |
| 데이터 저장 | Realm, FileManager |
| 이미지 캐시 | 자체 개발 라이브러리 SNKit (ETag 지원 포함), Kingfisher |
| 기타       | YouTube-Player-iOS-Helper |

---

## 트러블슈팅 및 해결 사례

### 1. 네트워크 단절 대응
- **문제**: 다중 네트워크 모니터 인스턴스로 인한 리소스 낭비
- **해결**: `NwPathMonitor`를 싱글톤으로 구현해 시스템 자원 최적화

### 2. 에러 처리 일관성 문제
- **해결**: `Coordinator` 패턴과 `Delegate` 패턴을 적용한 중앙 에러 처리 시스템 구축

### 3. CI/CD 문제
- **문제**: GitHub Actions에서 .gitignore로 인해 필요한 인증/설정 파일이 누락됨
- **해결**: GitHub Secrets + Base64 인코딩 방식으로 필요한 파일을 동적 생성

### 4. 이미지 캐싱 성능 문제
- **문제**: 빠른 스크롤 시 이미지가 잘못된 셀에 표시되거나 UI Freezing 현상 발생
- **해결**:
  - 약한 참조(weak self) 적용
  - 이미지 식별자 비교로 캐시 정확성 확보
  - SNKit 이미지 캐시 시스템 도입 (메모리/디스크/ETag)

---

## 🔗 앱스토어

 [앱스토어](https://apps.apple.com/us/app/%EC%99%80%EB%9E%84%EB%9D%BC-warala/id6744003128)

