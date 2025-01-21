git reset --soft origin/master
git -P diff -U0
echo -en "Provide a commit message:\n# "
read msg
git commit -m "$msg"
git push --force
