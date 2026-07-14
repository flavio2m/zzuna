#!/bin/bash

echo "🚀 Iniciando processo de build e deploy..."

# 1. Atualiza a versão e data no sobre_page.dart
echo "📝 Extraindo versão do pubspec.yaml..."
# Pega a versão do pubspec (ex: 1.0.0+1) e remove tudo após o +, mantendo apenas 1.0.0
VERSION=$(grep -E '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
CURRENT_DATE=$(date +"%d/%m/%Y %H:%M")

echo "📝 Atualizando sobre_page.dart com a versão $VERSION e data $CURRENT_DATE..."

# Atualiza diretamente o arquivo sobre_page.dart
sed -i "s|String _version = '.*';|String _version = '$VERSION';|g" lib/ui/home/pages/sobre_page.dart
sed -i "s|String _dataAtualizacao = '.*';|String _dataAtualizacao = '$CURRENT_DATE';|g" lib/ui/home/pages/sobre_page.dart

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
