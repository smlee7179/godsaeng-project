# 🔧 MongoDB Atlas 네트워크 액세스 설정 가이드

## ⚠️ 현재 상황

- ✅ 로컬 IP 주소 (118.235.84.253/32) 추가됨
- ❌ Render 서버 IP 주소는 추가되지 않음

## 문제

Render 서비스는 **동적 IP 주소**를 사용합니다. 즉:
- Render 서비스의 IP 주소는 변경될 수 있음
- 로컬 IP 주소만 추가하면 Render에서 연결할 수 없음
- SSL 핸드셰이크 오류는 네트워크 액세스 문제일 가능성이 높음

## 해결 방법

### MongoDB Atlas에 "Allow Access from Anywhere" 추가

**단계별 가이드**:

1. **MongoDB Atlas 대시보드 접속**
   - https://cloud.mongodb.com 접속
   - 프로젝트 선택

2. **Network Access 메뉴 클릭**
   - 왼쪽 사이드바에서 "Network Access" 클릭

3. **"Add IP Address" 버튼 클릭**

4. **"Allow Access from Anywhere" 선택**
   - "Allow Access from Anywhere" 버튼 클릭
   - 또는 IP Address 필드에 직접 입력: `0.0.0.0/0`
   - Comment: "Render deployment" (선택사항)

5. **"Confirm" 클릭**

6. **변경사항 적용 대기**
   - ⚠️ **중요**: 변경사항이 적용되기까지 최대 5분 소요될 수 있습니다
   - IP 주소 목록에 `0.0.0.0/0`이 표시되고 상태가 "Active"가 될 때까지 대기

## 체크리스트

- [ ] MongoDB Atlas 대시보드 접속
- [ ] Network Access 메뉴 클릭
- [ ] "Add IP Address" 클릭
- [ ] "Allow Access from Anywhere" 선택 또는 `0.0.0.0/0` 입력
- [ ] "Confirm" 클릭
- [ ] IP 주소 목록에 `0.0.0.0/0` 추가됨 확인
- [ ] 상태가 "Active"가 될 때까지 대기 (최대 5분)

## ⚠️ 보안 고려사항

**`0.0.0.0/0` (모든 IP 허용)**:
- ✅ 개발 환경에서는 안전함
- ✅ 무료 티어에서 일반적으로 사용됨
- ⚠️ 프로덕션 환경에서는 특정 IP만 허용하는 것을 권장

**프로덕션 환경 권장 설정**:
- Render 서비스의 실제 IP 주소를 찾아서 추가
- 하지만 Render는 동적 IP를 사용하므로 `0.0.0.0/0` 사용이 실용적

## 완료 후 확인

네트워크 액세스 설정이 완료되면:

1. **최대 5분 대기** (변경사항 적용 시간)

2. **Render 서비스 재시작**
   - Render 대시보드에서 서비스를 수동으로 재시작하거나
   - 새로운 배포를 트리거하면 자동으로 재시작됨

3. **로그 확인**
   - Render 대시보드 → Logs 탭
   - "✅ MongoDB 연결 성공" 메시지 확인
   - SSL 핸드셰이크 오류 없음 확인

4. **헬스체크 확인**
   - https://godsaeng-backend.onrender.com/health
   - 데이터베이스 연결 상태 확인

## 문제가 계속되면

만약 `0.0.0.0/0`을 추가한 후에도 문제가 계속되면:

1. **연결 문자열 확인**
   - MongoDB Atlas에서 최신 연결 문자열 복사
   - 비밀번호 정확성 확인

2. **환경 변수 확인**
   - Render 대시보드에서 MONGODB_URL 환경 변수 확인
   - 연결 문자열이 올바르게 설정되어 있는지 확인

3. **로컬에서 테스트**
   - 로컬에서 연결 테스트 스크립트 실행
   - 연결 문자열이 로컬에서는 작동하는지 확인

---

**가장 중요한 단계: MongoDB Atlas Network Access에 `0.0.0.0/0` 추가하기!** ✅

이것이 대부분의 SSL 핸드셰이크 오류를 해결합니다.

