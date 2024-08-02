#!/bin/bash
filePath="/home/lucasreginatto/git/git-work-commits/git-work-commits-data.txt"

# Iterar por cada repositório na pasta ~/git
for repo in "$HOME/git"/*; do
    if [ -d "$repo/.git" ]; then
        echo "Processando repositório: $repo"
        cd "$repo" || continue

        # Obter todas as branches locais criadas pelo autor
        branches=$(git for-each-ref --format="%(refname:short) %(authorname) %(authoremail)" refs/heads/ | grep "lucas.reginatto@ifood.com.br" | awk '{print $1}')

        for branch in $branches; do
            echo "  Processando branch: $branch"
            git checkout "$branch" &>/dev/null || continue

            commits=$(git log --author="lucas.reginatto@ifood.com.br" --pretty=format:"%h|%ae|%ad|$(git symbolic-ref --short HEAD)|%s|$(basename $(git rev-parse --show-toplevel))" --abbrev=8 --date=iso)
            
            # Salvar os commits no arquivo
            echo "$commits" >> $filePath
        done
    fi
done
