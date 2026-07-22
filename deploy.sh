#!/bin/bash
# Nasazení neveřejných landing pages na GitHub Pages → https://<user>.github.io/eva-nabidka/
set -e
REPO="eva-nabidka"
DIR="$(cd "$(dirname "$0")" && pwd)"
USER=$(gh api user -q .login)
echo "▶ účet: $USER"
gh repo view "$USER/$REPO" >/dev/null 2>&1 || { echo "▶ zakládám repo…"; gh repo create "$USER/$REPO" --public >/dev/null; }
cd "$DIR"
[ -d .git ] || git init -q
git add -A
git -c user.email=frantisekdron@gmail.com -c user.name="Frantisek Dron" commit -qm "landing pages — eva nabidka $(date +%F)" || echo "ℹ️ beze změny"
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$USER/$REPO.git"
git push -u -f -q origin main
# zapnout Pages (main / root) — POST, fallback PUT když už existuje
gh api -X POST "repos/$USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || gh api -X PUT "repos/$USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
echo "✅ LIVE (do ~1 min): https://$USER.github.io/$REPO/"
echo "   · https://$USER.github.io/$REPO/kamenny-privoz.html"
echo "   · https://$USER.github.io/$REPO/pacov-dum.html"
echo "   · https://$USER.github.io/$REPO/chata-sazava.html"
echo "   · https://$USER.github.io/$REPO/byt-vyhled.html"
