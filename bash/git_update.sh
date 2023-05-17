update_main(){
	if [ $# -ne 2 ]; then
		echo "Usage: update_main <file or -A> <commit message>"
		return 1
	fi

    git add $1
    git commit -m "$2"
    git checkout main
    git merge dev
    git checkout dev
}

update_dev(){
	if [ $# -ne 2 ]; then
		echo "Usage: update_dev <file or -A> <commit message>"
		return 1
	fi

    git add $1
    git commit -m "$2"
    git checkout dev
    git merge main
    git checkout main
}

push_main(){
	if [ $# -ne 1 ]; then
		echo "Usage: push_main <commit message>"
		return 1
	fi

	git add -A
	git commit -m "$1"
	git push origin main

}
