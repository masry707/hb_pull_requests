A simple website to show the pull request of some repo with the number of changes (addition and deletions) in ascending in the same view.

#### How to use it?
1. Create use .env file in the root directory
2. Add the following environment variables:
   1. REPO: The repository you want to see its PRs.
   2. PERSONAL_ACCESS_TOKEN: Your github access token, [read more](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token).
   3. GITHUB_USERNAME: A Github handle.
   4. GROUPING_LABEL: [Optional] in any case you want to see some label at the first of the view always so you should add this label here.
3. Run `bunle install`.
4. Finally run `./server.sh`.