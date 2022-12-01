
# Movie List

List out Movies from *the Movie db* using pagination, this app is demo project for interview
- App using MVVM architecure
- App should contains unit test


## BDD

### Story: Customer request to see Movie feeds
### Narrative #1

```
As an online customer
I want the app to automatically load my latest movie feed
also can see details of Movie
Add movie into favorite list
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
 Then the app should display error message 

Given the customer have connectivity
 Then the app should display Movie
```

## Use Cases

### Load Movie From Remote Use Case

#### Data:
- URL
- PageNumber

#### Primary course (happy path):
1. Execute "Load Movie Feed" command with above data.
2. System downloads data from the URL.
3. System creates Movie feed data.
4. System delivers Movie feed.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.
