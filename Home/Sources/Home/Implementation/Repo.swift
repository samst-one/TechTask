actor Repo {
    var currentOverview: Overview?

    func set(_ overview: Overview) async {
        currentOverview = overview
    }
}
