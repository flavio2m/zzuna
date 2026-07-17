#!/bin/bash

# Guarda o estado original do .env
RESTORE_ENV=false
ENV_FILE=".env"

# Função para restaurar o .env caso seja modificado
cleanup() {
  if [ "$RESTORE_ENV" = true ]; then
    echo "🔄 Restaurando USE_LOCAL_STORAGE para true no $ENV_FILE..."
    sed -i "s/^USE_LOCAL_STORAGE=false/USE_LOCAL_STORAGE=true/" "$ENV_FILE"
  fi
}

# Registra o trap para sempre rodar o cleanup quando o script terminar (com sucesso ou erro)
trap cleanup EXIT INT TERM

echo "🚀 Iniciando processo de build e deploy..."

echo "🔍 Verificando USE_LOCAL_STORAGE no $ENV_FILE..."
if grep -q "^USE_LOCAL_STORAGE=true" "$ENV_FILE"; then
  echo "⚠️ USE_LOCAL_STORAGE está como true. Alterando para false temporariamente para o deploy..."
  sed -i "s/^USE_LOCAL_STORAGE=true/USE_LOCAL_STORAGE=false/" "$ENV_FILE"
  RESTORE_ENV=true
fi

# 1. Atualiza a versão e data no sobre_page.dart
echo "📝 Extraindo versão do pubspec.yaml..."
# Pega a versão do pubspec (ex: 1.0.0+1) e remove tudo após o +, mantendo apenas 1.0.0
VERSION=$(grep -E '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
CURRENT_DATE=$(date +"%d/%m/%Y %H:%M")

echo "📝 Atualizando sobre_page.dart com a versão $VERSION e data $CURRENT_DATE..."

# Atualiza diretamente o arquivo sobre_page.dart
sed -i "s|final _version = '.*';|final _version = '$VERSION';|g" lib/ui/home/pages/sobre_page.dart
sed -i "s|final _dataAtualizacao = '.*';|final _dataAtualizacao = '$CURRENT_DATE';|g" lib/ui/home/pages/sobre_page.dart

if [ $? -ne 0 ]; then
  echo "❌ Erro ao atualizar versão no SobrePage"
  exit 1
fi

# 2. Faz o build do Flutter Web
echo "🔨 Fazendo build do Flutter Web..."
flutter build web --release --no-tree-shake-icons

if [ $? -ne 0 ]; then
  echo "❌ Erro no build"
  exit 1
fi

# 3. Faz o deploy no Firebase
echo "☁️  Fazendo deploy no Firebase Hosting..."
firebase deploy --only hosting

if [ $? -ne 0 ]; then
  echo "❌ Erro no deploy"
  exit 1
fi

echo "✅ Deploy concluído com sucesso!"
