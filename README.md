# AnnotateControllers

Annotate Rails controllers with routes information.

    class PostsController < ApplicationController
    
      # posts GET /posts
      def index
      end
    
      # posts POST /posts
      def create
      end
    
      # new_page GET /posts/new
      def new
      end
    
      # post GET /posts/:id
      def show
      end
    
      # edit_post GET /posts/:id/edit
      def edit
      end
    
      # post PATCH /posts/:id
      # post PUT /posts/:id
      def update
      end
    
      # post DELETE /posts/:id
      def destroy
      end
    
    end

**Note: This tool assumes you are using Rails standards for folder structures (e.g. /app/controllers) as well as naming conventions (snake\_case) for your controllers.** For example, if you have a class `HomeController`, your filename should be `home_controller.rb` as opposed to "HomeController.rb". This isn't Javascript :stuck\_out\_tongue\_winking\_eye:

## Installation

Add this line to your application's Gemfile:

    gem 'annotate_controllers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install annotate_controllers

## Usage

    $ rake annotate_controllers

## WARNING

**If you'd like to add comments before your action definitions in the controllers, make sure to add a blank line immediately after the comment.** This tool will blow away any consecutive comments added before your actions.

The correct way:

    # This comment is safe
    
    def index
    end

The wrong way:

    # This comment will be obliterated
    def index
    end

Be sure to check the changes that this tool makes! If you are using Git, you may simply check your project's status after annotating:

    $ git status

If you are not using a VCS (like Git, Subversion or similar), then you should consider stopping being a pleb, and just do it.

## Contributing

1. Fork it ( https://github.com/mmichael0413/annotate_controllers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
