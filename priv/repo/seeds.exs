# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TinyBunyan.Repo.insert!(%TinyBunyan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
proj1 = TinyBunyan.Repo.insert!(%TinyBunyan.Projects.Project{name: "Project 1"})

for i <- 1..10 do
  TinyBunyan.Repo.insert!(
    %TinyBunyan.Logs.Log{
      content: %{data: "test#{i}"}, 
      project_id: proj1.project_id, 
      fired_at: DateTime.truncate(DateTime.utc_now(), :second)
    })
end
