#!/bin/bash

echo "🚀 Iniciando processo de build e deploy..."

# 1. Atualiza a versão no index.html
# echo "📝 Atualizando versão no index.html..."
# dart run tool/update_version.dart
# 
# if [ $? -ne 0 ]; then
#   echo "❌ Erro ao atualizar versão"
#   exit 1
# fi

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
