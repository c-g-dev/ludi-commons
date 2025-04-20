package ludi.commons.pattern;

abstract class Repo {
	var repoState:RepoState;

	public function new(repoState:RepoState) {
		this.repoState = repoState;
	}
}
