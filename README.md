# 박스 오피스 </br>
> 영화 순위 및 영화 상세내용 </br>

## 📚 목차</br>
- [팀원소개](#-팀원-소개)
- [파일트리](#-파일트리)
- [타임라인](#-타임라인)
- [실행화면](#-실행화면)
- [트러블 슈팅](#-트러블-슈팅)
- [참고자료](#-참고자료)

## 🧑‍💻 팀원 소개</br>
| <img src="https://avatars.githubusercontent.com/u/24710439?v=4" width="250" height="250"/> | <img src="https://github.com/hemg2/TIL/assets/101572902/94246a3f-4b06-4b37-abfd-6bab0d345ebb" width="250" height="250"/> |
| :-: | :-: |
| [**Zion**](https://github.com/LeeZion94) | [**Hemg**](https://github.com/hemg2) |

## 🗂️ 파일트리</br>


## ⏰ 타임라인</br>
프로젝트 진행 기간 | 23.07.24.(월) ~ 23.08.11.(금)

| 날짜 | 진행 사항 |
| -------- | -------- |
| 23.07.24.(월     | box_office_sample Model 구현<br> Model Type XCTest 구현|
| 23.07.25.(화)    | XCTest code 접근제어자 수정 <br> Equatable -> XCTest에서만 적용 변경 진행|
| 23.07.27.(목)    | API, Networking 타입 구현, 네트워크 로직 수정 <br> showNetworkFailAlert 생성|
| 23.07.31.(월)    | APIResult -> ResultType 변경 <br> UseCase 생성 DTO 모델 구현 |
| 23.08.01.(화)    | Repository 재사용 기능 분리 |
| 23.08.03.(목)    | CollectionView, ListCell 생성 <br> ActivityIndicatorView, RefreshContro 생성 <br> |
| 23.08.07.(월)    | 타켓 13 -> 14.5 상승 <br> 타켓 상승에 맞는 메서드 수정[(Button: addTarger -> Action),  weak,self 참조 진행]  |
| 23.08.09.(수)    | MovieDetailVC 생성 <br> DaumSearchRepository, UseCase 추가 <br> AppCoordinator 생성 <br> |
| 23.08.10.(목)    | setUpRequestURL 프로토콜생성 <br> setUpRequestURLTests 생성 |
| 23.08.11.(금)    | README 작성 |


## 📺 실행화면
- BoxOffice 실행 화면 </br>

| 영화 리스트 상세정보 | 날짜 변경 |
| :--------: | :--------: |
|<Img src = "https://cdn.discordapp.com/attachments/1080783877594947597/1139467267990638654/6b6c9458f4ac2428.gif" width="300" height="600">|<Img src = "https://cdn.discordapp.com/attachments/1080783877594947597/1139467268435226694/0b3dc23857a3754a.gif" width="300" height="600"> |

## 🔨 트러블 슈팅 
1️⃣ **1** </br>
🔒 **문제점** </br>
ViewController에서 네트워킹을 통해 Data를 Fetch해오는 로직까지 가지고 있었기 때문에 ViewController가 너무 방대해졌고 하는 일이 너무 많아졌습니다. 따라서 이를 해결하기 위해 역할 및 기능을 나눌 필요성을 느꼈습니다.

🔑 **해결방법** </br>
Clean Architecture를 적용하여 기능 및 역할 별로 여러개의 Layer로 나눈 뒤 각각의 의존성을 주입받아 ViewController의 기능 및 역할을 줄이고 ViewController가 방대해지는 문제를 해결할 수 있었습니다.

처음 적용할 때 부터 Clean Architecture의 형태로 적용하려고 했었던 것은 아니었습니다. ViewController를 통해 User가 할 수 있는 동작에 대응하는 UseCase 타입을 따로 두어 ViewController의 방대함을 해결하려 했습니다만, 그렇게 되자 UseCase에서 네트워킹을 통해 data를 Fetch하는 로직을 들고 있게 되기 때문에 data를 Fetch하는 로직 자체를 재활용할 수가 없게 된다는 문제점이 있었습니다. 따라서 이러한 문제를 해결하기 위해 해당 Data Fetch를 재활용하여 사용할 수 있게 Repository 타입을 두어서 재활용 할 수 있도록 했습니다.

최대한 Data를 Fetch하는 로직을 줄이고 재활용했다는 점과 ViewController의 방대함을 해결하고 기능분리를 했다는 점에서 의미가 있었다고 생각합니다.

2️⃣ **2**</br>
🔒 **문제점 2** </br>
```swift
        // Background Queue
        snapShot.appendSections([.main])
        snapShot.appendItems(movieInformationDTOList)
        DispatchQueue.main.async {
            self.diffableDataSource?.apply(snapShot)
        }
```
ModernCollectionView 중 UICollectionViewDiffableDataSource의 사용에서 바뀌어진 SnapShot을 Apply하는 코드를 MainThread에서 실행될 수 있도록 불필요하게 옮겨서 사용했습니다.

🔑 **해결방법** </br>
DiffableDataSource를 Apply하는 코드는 의도적으로 MainThread로 옮겨서 실행될 필요가 없습니다. 
현재 data를 갱신하는 코드는 Background Queue에서 진행이되고 있지만 현재의 UI State와 바뀌어진 UI State에서의 SnapShot의 Diff 계산이 끝났다면 자체적으로 내부에서 MainThread 옮겨서 UI 갱신을 해주기 때문에 개발자가 따로 해당 코드를 MainThread에서 옮겨서 진행할 필요가 없습니다.

3️⃣ **3**</br>
🔒 **문제점 3** </br>
StackView 내부에 여러개의 StackView를 넣었을 때 각각의 StackView에 내부 컴포넌트들의 IntrisicContentSize만큼 크기를 잡지 못하고 오류가 발생했습니다.

🔑 **해결방법** </br>
이를 해결하기 위해 2가지 방법을 사용했습니다.

## Alignment.Fill option이란?
> A layout where the stack view resizes its arranged views so thye fill the available space perpendicular to the stack view’s axis
> 
- Alignment.Fill option은 내부 컴포넌트의 intrinsicContentSize 만큼 StackView의 사이즈 자체를 맞춰주는(resize) option이다.
- 즉 따로 StackView size에 해당하는 조건은 부여하지 않아도 내부 컴포넌트의 intrinsicContentSize를 기준값으로 잡아 StackView의 size를 맞춰준다는 의미의 option이다.
- 해당 옵션을 부여하면 더이상 애매한 StackView width나 height를 가지지 않는다. 내부 컴포넌트의 size를 통해 현재 size를 유추할 수 있기 때문!

## ContentHugging Priority란?

- 현재 자신의 크기에 대해 컨텐츠가 늘어나지 않고 유지하려는 우선순위이다.
- 쉽게 말해서 axis(horizontal, vertical)에 StackView 내부에 존재하는 컴포넌트가 Content Hugging Priority가 더 낮은 컴포넌트가 존재한다면 상위 StackView의 크기가 커졌을 때 Content Hugging Priority가 더 낮은 컴포넌트의 크기가 덩달아 늘어난다는 의미이다. 왜? 우선순위가 더 낮으니까!
- Horizontal, Vertical의 기본 우선순위는 Low: 250, High: 750으로 부여되어 있으며 해당 값보다 기준으로 더 낮다면 해당 컴포넌트가 상위 StackView에 의해 크기가 늘어나게된다.

## StackView 내부에서 기준이 되는 값을 지정해주기

- StackView가 명확한 width, height를 갖지 못하는 경우가 반드시 존재한다 이는 StackView 내부에 StackView가 존재할 수도 있고 생각보다 복잡하게 활용될 수 있기 때문이다.
- 따라 위와 같은 이슈가 발생할 때는 StackView가 크기를 유추할 수 있게 옵션을 부여하는 것이 중요하다! → 기준값 설정 (Alignment.Fill option 사용)
- 또한 상위 StackView의 크기에 따라 내부의 StackView나 다른 컴포넌트들의 크기가 늘어나야할 경우 여기서도 어떠한 컴포넌트가 늘어나야할지 정해져 있지 않다면 내부 컴포넌트들의 크기를 StackView가 유추할 수 없기에 ContentHuggingPriority를 조절해야한다. 이렇게 조절함으로써 어떠한 컴포넌트가 늘어나야할지 지정해줄 수 있으므로 해당 컴포넌트의 크기가 증가하여 그 크기를 기준으로 내부 Size를 잡아줄 수 있다.

## 결론

- StackView 사용시 내부 크기가 애매하게 지정되어잇따면 ContentHugging과 Alignment.Fill option으로 내부 크기에 대한 기준을 잡아줄 수 있음을 기억하자!



## 📑 참고자료
- [📃 URLSession](https://developer.apple.com/documentation/foundation/urlsession)</br>
- [📃 Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)</br>
- [📃 Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)</br>
- [📃 Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)</br>
- [📃 UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)</br>
- [📃 UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)</br>
- [🎥 WWDC - Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)</br>
- [🎥 WWDC - Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)</br>
- [📃 Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)</br>
- [📃 Entering data](https://developer.apple.com/design/human-interface-guidelines/entering-data)</br>
