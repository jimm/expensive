# Expensive

A bank statement manager / budget reporter. Imports CSV files from my bank,
assigns categories to transactions, reports on monthly and yearly
expenditures, and more.

I'm using this project to learn the
<a href="http://www.phoenixframework.org/">Phoenix</a> Web framework.

# Application Notes

## Models

- Category categories
  - description:string

- CategoryRegex category_regexes
  - category_id:references:categories
  - regex:string

- Transaction transactions
  - year:integer
  - month:integer
  - day:integer
  - amount:integer
  - description:string
  - type:text
  - notes:text
  - category_id:references:categories

- Check checks
  - transaction_id:references:transactions
  - description:text

## Major Functionality

- Import bank statements
  - Old statements, one-time import must handle older formats
  - New statements
- Categories
  - Automatic assignment
  - Store regexes in database?
  - Edit them
- Checks
  - Id is check number
  - Created manually or when txn is imported
- Export tax info
- Export/display monthly and yearly spend individually and by category

# Phoenix

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please
[check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
