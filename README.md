# ResuelveFCPayroll

Command Line Program to calculate ResuelveFC Payroll based on the rules described in https://github.com/resuelve/prueba-ing-backend

### Dependencies

* Erlang 24.2
* Elixir 1.13.1

### Installation

* Clone repository:
  * ```bash
    git clone https://github.com/vegg89/resuelve_fc_payroll.git
    ```
* Get dependencies:
  * ```bash
    mix deps.get
    ```
* Generate executable:
  * ```bash
    mix escript.build
    ```

A executable called `resuelve_fc_payroll` will be created in the root of the project 

### Running

#### Basic usage

You can calculate the payroll using the following command in a terminal:

```bash
./resuelve_fc_payroll '{
  "players": [
    {
      "name": "Luis",
      "bonus": 10000,
      "goals": 19,
      "level": "Cuauh",
      "salary":50000
    }
  ]
}'
```

You can add as many players as you want:


```bash
./resuelve_fc_payroll '{
  "players": [
    {
      "name": "Luis",
      "bonus": 10000,
      "goals": 19,
      "level": "Cuauh",
      "salary":50000
    },
    {
      "name": "Juan",
      "bonus": 12000,
      "goals": 19,
      "level": "A",
      "salary":60000
    }
  ]
}'
```

#### BONUS: Multiple teams

You can calculate payroll for several teams you just need to use a JSON as follow:

```zsh
./resuelve_fc_payroll '{
  "teams": [
    {
      "name": "blue",
      "players": [
        {
          "name": "Luis",
          "salary": 50000,
          "bonus": 10000,
          "level": "Cuauh",
          "goals": 19
        },
        {
          "name": "Juan",
          "salary": 20000,
          "bonus": 1000,
          "level": "B",
          "goals": 8
        }
      ]
    },
    {
      "name": "red",
      "players": [
        {
          "name": "Pedro",
          "salary": 40000,
          "bonus": 15000,
          "level": "A",
          "goals": 3
        }
      ]
    }
  ]
}'
```

#### BONUS: Custom rules

When using mutiple teams JSON you can define specific rules for each team, by default all teams use ResuelveFC rules. If you want to define a rule for a specific team you need to add `minimum_goals` key to the desired team as follow:


```zsh
./resuelve_fc_payroll '{
  "teams": [
    {
      "name": "blue",
      "players": [
        {
          "name": "Luis",
          "salary": 50000,
          "bonus": 10000,
          "level": "Cuauh",
          "goals": 19
        },
        {
          "name": "Juan",
          "salary": 20000,
          "bonus": 1000,
          "level": "CustomLevelName",
          "goals": 8
        }
      ],
      "minimum_rules": {
        "A": 12,
        "B": 13,
        "CustomLevelName": 34
      }
    },
    {
      "name": "red",
      "players": [
        {
          "name": "Pedro",
          "salary": 40000,
          "bonus": 15000,
          "level": "A",
          "goals": 3
        }
      ]
    }
  ]
}'
```

