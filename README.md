# Energy Consumption App

This is a Ruby on Rails application for tracking and managing energy consumptions.

## Technologies Used

*   Ruby on Rails
*   Hotwire
*   TailwindCSS
*   Devise
*   Ransack

## Setup

### Prerequisites

*   Ruby: `3.4.5`
*   Rails: `8.0.3`
*   Bundler
*   SQLite3 (gem version `>= 2.1`)


### Installation

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    cd energy_consumption
    ```
2.  Install Ruby dependencies:
    ```bash
    bundle install
    ```

4.  Set up the database:
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

## Running the Application

To start the Rails server:

```bash
rails s
```

The login page is at [http://0.0.0.0:3000/users/sign_in](http://0.0.0.0:3000/users/sign_in).

email: test@example.com
password: password



## Testing
```bash
rails test
```
