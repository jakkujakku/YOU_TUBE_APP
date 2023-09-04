# YOU_TUBE App
내일배움 부트캠프 iOS 7기 심화과제 YOU_TUBE App 입니다. :)

## Git Flow
- main : 소프트웨어 제품을 배포하는 용도로 쓰는 브랜치
- develop : 개발용 default 브랜치로, 이 브랜치를 기준으로 feature 브랜치를 따고, 각 feature를 합치는 브랜치
- feature: 단위 기능 개발용 브랜치 -> feature/작업할페이지컨트롤러명

### Git Conventions
Commit Message는 아래와 같은 규칙을 따릅니다.

- [FEAT]: 새로운 기능을 추가
- [FIX]: 잔잔바리 수정
- [DESIGN]: UI 디자인 변경
- [STYLE]: 코드 포맷 변경, 세미 콜론 누락, 코드 수정이 없는 경우
- [DOCS]: 문서 수정, 필요한 주석 추가 및 변경
- [RENAME]: 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
- [REMOVE]: 파일을 삭제하는 작업만 수행한 경우
- [MERGE] : 병합
- [CONFLICT]: 병합 시 충돌 해결
- [COMPLETION]: 작업을 완료하고 마지막 커밋을 작성하는 경우
Pull Requests는 Commit Message와 동일하게 써서 올립니다.
