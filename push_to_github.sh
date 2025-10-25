#!/bin/bash

# 🚀 Kubernetes Manager - Automatyczny Git Push Script
# Ten skrypt wysyła Twój projekt do GitHub

set -e  # Zatrzymaj się na błędzie

echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                               ║"
echo "║           🚀 Kubernetes Manager - Automatyczny Git Push                      ║"
echo "║                                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Kolory dla tekstu
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Kroki
echo -e "${BLUE}📝 KROKI:${NC}"
echo "1. Sprawdzenie Git repozytorium"
echo "2. Pobranie danych od Ciebie"
echo "3. Konfiguracja GitHub remote"
echo "4. Wysłanie kodu na GitHub"
echo ""

# KROK 1: Sprawdzenie czy jesteśmy w git repozytorium
echo -e "${BLUE}[1/4]${NC} Sprawdzanie Git repozytorium..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Błąd: To nie jest Git repozytorium!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Git repozytorium znalezione${NC}"
echo ""

# KROK 2: Pobranie danych od użytkownika
echo -e "${BLUE}[2/4]${NC} Konfiguracja GitHub..."
echo ""

# Sprawdzenie czy istnieje już remote
if git remote get-url origin 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Zdalne repozytorium już istnieje:${NC}"
    git remote get-url origin
    echo ""
    read -p "Czy chcesz je zamieniać? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove origin
        echo -e "${GREEN}✅ Stare repozytorium usunięte${NC}"
    else
        echo -e "${RED}❌ Anulowanie${NC}"
        exit 1
    fi
fi

echo ""
read -p "Podaj swoją nazwę GitHub: " GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
    echo -e "${RED}❌ Nazwa GitHub nie może być pusta!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Wciśnij Enter aby użyć domyślnej nazwy repozytorium (k8s-manager)${NC}"
read -p "Nazwa repozytorium (default: k8s-manager): " REPO_NAME
REPO_NAME=${REPO_NAME:-k8s-manager}

echo ""
read -p "Czy używasz SSH czy HTTPS? (https/ssh, default: https): " CONNECTION_TYPE
CONNECTION_TYPE=${CONNECTION_TYPE:-https}

echo ""
echo -e "${YELLOW}WAŻNE: Jeśli wybiorłeś HTTPS, będziesz musiał podać Personal Access Token${NC}"
echo -e "${YELLOW}Instrukcja: https://github.com/settings/tokens/new${NC}"
echo ""

# KROK 3: Konfiguracja remote
echo -e "${BLUE}[3/4]${NC} Konfiguracja GitHub remote..."

if [ "$CONNECTION_TYPE" = "ssh" ]; then
    REMOTE_URL="git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
else
    REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
fi

echo "Remote URL: $REMOTE_URL"
echo ""

git remote add origin "$REMOTE_URL"
echo -e "${GREEN}✅ GitHub remote dodany${NC}"
echo ""

# Zmiana branch name
echo -e "${BLUE}Zmiana gałęzi na 'main'...${NC}"
git branch -M main
echo -e "${GREEN}✅ Branch zmieniony na 'main'${NC}"
echo ""

# KROK 4: Push
echo -e "${BLUE}[4/4]${NC} Wysyłanie kodu na GitHub..."
echo ""

echo -e "${YELLOW}📝 Instrukcje:${NC}"
echo "1. Jeśli git poprosi o hasło i używasz HTTPS:"
echo "   - Username: $GITHUB_USERNAME"
echo "   - Password: Wklej Personal Access Token (z GitHub settings)"
echo ""
echo "2. Jeśli używasz SSH, upewnij się że masz klucz SSH dodany do GitHub"
echo ""

echo -e "${BLUE}Wysyłanie...${NC}"
echo ""

git push -u origin main

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                      ✅ SUKCES!                          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

REPO_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo -e "${GREEN}✅ Twój projekt jest teraz na GitHub!${NC}"
echo ""
echo "🔗 Link do repozytorium:"
echo -e "${BLUE}$REPO_URL${NC}"
echo ""

echo -e "${GREEN}🎉 GOTOWE!${NC}"
echo ""
echo "Następne kroki:"
echo "1. Odwiedź $REPO_URL"
echo "2. Udostępnij link"
echo "3. Dodaj do portfolio"
echo "4. Rób zmiany i push-uj: git push"
echo ""
