#!/bin/bash

if [ -n "$1" ]; then
  opcao="$1"
else
  echo "Selecione uma opção:"
  echo "1) build  - Gera os arquivos uma vez"
  echo "2) watch  - Fica observando alterações e gera automaticamente"
  echo ""
  read -p "Opção [1/2]: " opcao
fi

case $opcao in
  1)
    echo "Executando build..."
    dart run routefly
    dart run build_runner build --delete-conflicting-outputs
    ;;
  2)
    echo "Executando watch..."
    dart run routefly
    dart run build_runner watch --delete-conflicting-outputs
    ;;
  *)
    echo "Opção inválida. Use 1 para build ou 2 para watch."
    exit 1
    ;;
esac
