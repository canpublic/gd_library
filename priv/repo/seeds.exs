# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GDLibrary.Repo.insert!(%GDLibrary.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

GDLibrary.Seeds.delete_all!()
GDLibrary.Seeds.insert_all!()
