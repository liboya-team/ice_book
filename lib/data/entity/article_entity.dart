class ArticleEntity {
	int novelId;
	int nextArticleId;
	int index;
	int id;
	int preArticleId;
	String title;
	String content;
	List<Map<String, int>> pageOffsets;
	ArticleEntity({this.novelId, this.nextArticleId, this.index, this.id, this.preArticleId, this.title, this.content});

	ArticleEntity.fromJson(Map<String, dynamic> json) {
		novelId = json['novelId'];
		nextArticleId = json['nextArticleId'];
		index = json['index'];
		id = json['id'];
		preArticleId = json['preArticleId'];
		title = json['title'];
		content = json['content'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['novelId'] = this.novelId;
		data['nextArticleId'] = this.nextArticleId;
		data['index'] = this.index;
		data['id'] = this.id;
		data['preArticleId'] = this.preArticleId;
		data['title'] = this.title;
		data['content'] = this.content;
		return data;
	}

	String stringAtPageIndex(int index) {
		var offset = pageOffsets[index];
		return this.content.substring(offset['start'], offset['end']);
	}

	int get pageCount {
		return pageOffsets.length;
	}
}
