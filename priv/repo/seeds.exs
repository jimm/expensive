# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Expensive.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Expensive.Repo
alias Expensive.Category
alias Expensive.CategoryRegex

Repo.delete_all(Category)
Repo.delete_all(CategoryRegex)

biz     = Repo.insert!(%Category{description: "Business"})
charity = Repo.insert!(%Category{description: "Charity"})
docs    = Repo.insert!(%Category{description: "Doctors"})
edu     = Repo.insert!(%Category{description: "Education"})
house   = Repo.insert!(%Category{description: "House"})
tax     = Repo.insert!(%Category{description: "Taxes"})

Repo.insert!(%CategoryRegex{regex: "^business$", category: biz})
Repo.insert!(%CategoryRegex{regex: "taxes business", category: biz})
Repo.insert!(%CategoryRegex{regex: "^charity$", category: charity})
Repo.insert!(%CategoryRegex{regex: "taxes charity", category: charity})
Repo.insert!(%CategoryRegex{regex: "^doctors$", category: docs})
Repo.insert!(%CategoryRegex{regex: "^Medical$", category: docs})
Repo.insert!(%CategoryRegex{regex: "taxes medical", category: docs})
Repo.insert!(%CategoryRegex{regex: "^education$", category: edu})
Repo.insert!(%CategoryRegex{regex: "taxes house", category: house})
Repo.insert!(%CategoryRegex{regex: "^taxes$", category: tax})
Repo.insert!(%CategoryRegex{regex: "tax preparation", category: tax})
Repo.insert!(%CategoryRegex{regex: "taxes", category: tax})
