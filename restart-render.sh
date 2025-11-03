#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Render 서비스 재시작 스크립트"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# GitHub에 빈 커밋 푸시하여 Render 자동 재배포 트리거
echo "1️⃣  GitHub에 빈 커밋 푸시 중..."
git commit --allow-empty -m "Trigger: Restart Render service $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Render 서비스 재시작 트리거 완료!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "⏳ 배포 진행:")
    echo "   → Render가 자동으로 재배포를 시작합니다"
    echo "   → 빌드 완료까지 약 5-10분 소요 예상"
    echo ""
    echo "📋 배포 상태 확인:")
    echo "   → Render 대시보드: https://dashboard.render.com"
    echo "   → 백엔드 서비스: godsaeng-backend"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "❌ GitHub 푸시 실패"
    echo "   → Git 설정을 확인하세요"
    exit 1
fi

