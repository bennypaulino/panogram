# P A N O G R A M

Sometimes the world just isn't square. Panogram is a panoramic-image sharing website, conceived before Instagram loosened their restrictions on only allowing square images.Built from the ground up using TDD with the help of mini-test.

## Technologies Used
Ruby on Rails 5
PostgreSQL
SASS
Bootstrap 3
Javascript
jQuery
AWS 

## Features
* Image cropping
* Post an image
* Favorite an image
* Follow / Unfollow users


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.


### Installing

* Clone the repo git clone git@github.com:bennypaulino/panogram.git
* Go to the folder cd panogram and run gem install bundle && bundle install
* Run rails db:setup && rails db:migrate to create db and included Users table


## Running the tests

Run rails test

### What is being tested?

End to end testing from invalid submission to a valid submission for a post, including cropping an image, deleting a post, visiting a different user, testing the number of posts a user has, and more.


```ruby
require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:krusty)
    @micropost = @user.microposts.build
    @comment = @micropost.comments.build
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type="file"]'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = "This micropost really ties the room together!"
    picture = fixture_file_upload('test/fixtures/donkey_kong.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content,
                                                   picture: picture } }
    end
    assert_response :success
    assert_template :crop
    #most_recent = assigns(:micropost)
    #assert most_recent.picture?
    # previous two lines are the same as saying the following:
    assert @user.microposts.first.picture?

    # request to edit picture
    patch micropost_path(@user.microposts.first), params: { "micropost"=>
                                                  {"crop_x"=>"239",
                                                   "crop_y"=>"21",
                                                   "crop_w"=>"256",
                                                   "crop_h"=>"274"} }

    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body

    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit different user (no delete links)
    get user_path(users(:lebowski))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "35 panograms", response.body

    # User with zero microposts
    other_user = users(:kenobi)
    log_in_as(other_user)
    get root_path
    assert_match "0 panograms", response.body
    other_user.microposts.create!(content: "That's no moon, it's a space station!")
    get root_path
    assert_match "1 panogram", response.body

    # User with zero panograms visits another user who has posted once
    log_in_as(users(:lebowski))
    get user_path(other_user)
    assert_match "1 panogram", response.body
  end
end
```



## Built With

* [Ruby on Rails 5.0](https://guides.rubyonrails.org/v5.0/) - The web framework used
* [Bootstrap](https://getbootstrap.com/docs/3.3/) - Dependency Management
* [Jcrop](https://github.com/tapmodo/Jcrop) - Used to generate RSS Feeds



## Acknowledgments

* carrierwave https://github.com/carrierwaveuploader/carrierwave
* minimagick https://github.com/minimagick/minimagick
* Inspired by the Ruby on Rails Tutorial by Michael Hartl
