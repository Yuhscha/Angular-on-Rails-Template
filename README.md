# Angular-on-Rails-Template

## Versions
|             |version|
|-------------|-------|
|TypeScript   |5.2.2  |
|Ruby         |3.3.0  |
|Angular      |17.1.1 |
|Ruby on Rails|7.1.3  |
|Redis        |7.2.4  |
|PostgreSQL   |16.1   |

## Setup

```bash
$ git clone git@github.com:Yuhscha/Angular-on-Rails-Template.git

$ cd Angular-on-Rails-Template

$ bash setup.sh
```

## Example

Create `rails_api/app/controllers/hello_controller.rb`
```ruby
class HelloController < ApplicationController
  def index
    render json: { message: 'Angular on Rails!' }
  end
end
```
Rewrite `rails_api/config/routes.rb`
```ruby
require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  mount Sidekiq::Web, at: "/sidekiq"

  get "/hello", to: "hello#index"
end
```
Rewrite `angular-web-front/src/app/app.component.ts`
```typescript
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})

export class AppComponent {
  url = 'http://localhost:3000'
  title: string = '';

  constructor(private http: HttpClient) {
    this.http.get(this.url + '/hello').subscribe(hello => {
      this.title = (hello as { message: string }).message;
    });
  }
}
```
```bash
$ docker-compose up
```
When you access `localhost:4200` and see the message "Hello, Angular on Rails!", you've succeeded!
