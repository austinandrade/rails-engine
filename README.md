<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** github_username, repo_name, twitter_handle, email, project_title, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/austinandrade/rails-engine">
    <img src="public/rails-engine-logo.png" alt="Logo" width="300" height="300">
  </a>
  
<!-- ABOUT THE PROJECT -->
## About The Project

Rails Engine is an api that grants the ability to CRUD data within a database via exposed endpoints. 


### Built With

* [Rubocop](https://github.com/rubocop/rubocop)
* [RubyOnRails](https://rubyonrails.org/)
* [PostgreSQL](https://www.postgresql.org/)
* [RSpec](https://rspec.info/)
* [Simplecov](https://github.com/simplecov-ruby/simplecov)
* [Capybara](https://github.com/teamcapybara/capybara)
* [ShouldaMatchers](https://github.com/thoughtbot/shoulda-matchers)

  
### Installation

1. Fork the repo
2. Clone the repo
   ```sh
   git clone git@github.com:your-username/rails-engine.git
   ```
3. Install dependencies
   ```sh
   bundle install
   ```
4. Create PostgreSQL database
  ```sh
  rake db:{drop,create,migrate,seed}
  ```
5. Create database schema and resources
  ```sh
  rails db:schema:dump
  ```
*Utilize Postman or localhost:3000 to CRUD present PostgreSQL records:*
#### All available endpoints: 
  1. Get All Merchants: http://localhost:3000/api/v1/merchants
  2. Get One Merchants: http://localhost:3000/api/v1/merchants/{merchant_id}
  3. Get a Merchant's Items: http://localhost:3000/api/v1/merchants/{merchant_id}/items
  4. Get all Items: http://localhost:3000/api/v1/items
  5. Get one Item: http://localhost:3000/api/v1/items/{item_id}
  6. Create or delete items: http://localhost:3000/api/v1/items
  7. Update an Item: http://localhost:3000/api/v1/items/{item_id}
  8. Get an Item's Merchant: http://localhost:3000/api/v1/items/{item_id}/merchant
  9. Find a Merchant by Name Fragment: http://localhost:3000/api/v1/merchants/find?name={case_insensitive_name_fragment}
  10. Find all Items by Name Fragment: http://localhost:3000/api/v1/items/find_all?name={case_insensitive_name_fragment}
  11. Get top n Merchant's Revenue: http://localhost:3000/api/v1/revenue/merchants?quantity={your_quantity}
  12. Get top n merchants who the Most Items: http://localhost:3000/api/v1/merchants/most_items?quantity={your_quantity}
  13. Get the revenue of a Merchant: http://localhost:3000/api/v1/revenue/merchants/{merchant_id}
  
  
<!-- USAGE EXAMPLES -->
## Accomplishments

- Learn how to expose an API
- Use serializers to format JSON responses
- Test API exposure
- Compose advanced ActiveRecord queries to analyze information stored in an SQL database

<!-- CONTACT -->
## Contact

Email - [austinmandrade@gmail.com](austinmandrade@gmail.com)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/austinandrade/
