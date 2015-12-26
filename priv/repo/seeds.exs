# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Expensive.Repo.insert!(%Expensive.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Expensive.Repo
alias Expensive.Category
alias Expensive.CategoryRegex

Repo.delete_all(CategoryRegex)
Repo.delete_all(Category)

biz     = Repo.insert!(%Category{description: "Business"})
charity = Repo.insert!(%Category{description: "Charity"})
docs    = Repo.insert!(%Category{description: "Doctors"})
edu     = Repo.insert!(%Category{description: "Education"})
house   = Repo.insert!(%Category{description: "House"})
tax     = Repo.insert!(%Category{description: "Taxes"})

Repo.insert!(%CategoryRegex{regex: "business", category_id: biz.id})
Repo.insert!(%CategoryRegex{regex: "charity", category_id: charity.id})
Repo.insert!(%CategoryRegex{regex: "doctors|[Mm]edical", category_id: docs.id})
Repo.insert!(%CategoryRegex{regex: "education", category_id: edu.id})
Repo.insert!(%CategoryRegex{regex: "house", category_id: house.id})
Repo.insert!(%CategoryRegex{regex: "preparation", category_id: tax.id})
Repo.insert!(%CategoryRegex{regex: "taxes", category_id: tax.id})
