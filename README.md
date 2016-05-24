# AnnotateControllers

Annotate Rails controllers with routes information.

    class PagesController < ApplicationController

      # GET / (root_path)
      # GET /pages (pages_path)
      def index
      end
    
      # POST /pages (pages_path)
      def create
      end
      
      # GET /pages/new (new_page_path)
      def new
      end
    
      # GET /pages/:id (page_path)
      def show
      end
    
      # GET /pages/:id/edit (edit_page_path)
      def edit
      end
    
      # PATCH /pages/:id (page_path)
      # PUT /pages/:id (page_path)
      def update
      end
    
      # DELETE /pages/:id (page_path)
      def destroy
      end

    end

**Note: This tool assumes you are using Rails standards for folder structures (e.g. /app/controllers) as well as naming conventions (snake\_case) for your controllers.** For example, if you have a class `HomeController`, your filename should be `home_controller.rb` as opposed to `HomeController.rb`. This isn't Javascript :stuck\_out\_tongue\_winking\_eye:

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

**Be sure to check the changes that this tool makes!** If you are using Git, you may simply check your project's status after annotating:

    $ git status

If you are not using a VCS (like Git, Subversion or similar), then you should consider stopping being a pleb, and just do it.

## Contributing

1. Fork it ( https://github.com/mmichael0413/annotate_controllers/fork )
2. Create your feature branch (`git checkout -b my_dope_new_feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin my_dope_new_feature`)
5. Create a new Pull Request
