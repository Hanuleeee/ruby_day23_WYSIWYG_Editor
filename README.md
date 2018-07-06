# 20180706_Day19

### 복습

* 기능을 구현하고자 할때, 그 과정들을 세분화하는 것이 중요하다.
* 레일즈 프로젝트에서 ajax를 구현하기 위해서는 다음과 같은 순서를 갖는다.

> * 모든 동작을 포함하는 js코드를 작성한다.
> * ajax 코드를 작성한다.
> * url을 지정한다.
> * 해당 url을 *config/routes.rb* 에서 controller#action 을 지정한다.
> * controller#action을 작성한다.
> * *app/views/controller_name*에 action명과 일치하는 `js.erb` 파일을 작성한다.





### gem faker

- seed 파일을 통해 데이터를 랜덤으로 생성  

> <https://github.com/stympy/faker> 



*Gemfile* 에  `gem 'faker'`  추가



*db/seeds.rb*

```ruby
genres = ["Horror", "Thriller", "Action", "Drama", "Comedy", "Romance", "SF", "Adventure"]
images = %w(...)
# 배열만들때 %w 를 써서 space로 구분가능

30.times do
movie = Movie.create(title: Faker::Movie.quote,
                      genre: genres.sample,
                      director: Faker::FunnyName.name_with_initial,
                      actor: Faker::Name.name,  
                      description: Faker::Lorem.paragraph,
                      remote_image_path_url: images.sample,
                      user_id: 1)
end
```



 `rake db:drop`: migrate 파일을 수정했을때

 `rake db:reset`: drop + migrate + seed 한번에 실행





## 영화 검색하기

* input 창에 글자를 한글자 입력할때마다(이벤트리스너)

* server로 해당 글자를 검색하는 요청을 보내고

* 응답으로 날아온 영화제목 리스트를 화면에 보여준다.

  

*views/movies/index.html.erb*

> [bootstrap](https://getbootstrap.com/docs/4.1/utilities/flex/#justify-content) 여기서 bootstrap class를 찾아서 사용

```erb
<h1 id="title">Movies</h1>
<input type="text" class="form-control movie-title">
<div class="recomm-movie d-flex justify-content-start row">
</div>
....
<script>
...
   $(document).on('ready', function(){
     $('.movie-title').on('keyup', function(){
       $('.recomm-movie').html('');  // 검색하고 나서 지웠을 때 정보 사라지도록
       var title=$(this).val();
       $('.recomm-movie').html(`<a>${$(this).val()}</a>`);
       $.ajax({
         url: '/movies/search_movie',  //요청보내기
         data: {
           q: title
         }
       })
     })
   });
</script>
```



*routes.rb*

```ruby
  resources :movies do
    collection do
      ...
      get '/search_movie' => 'movies#search_movie'   #추가
    end
  end
```



*app/controllers/movies_controller.rb*

```ruby
...
  def search_movie
    #원래는 이 액션명과 일치하는 js파일을 찾아서 data를 보내줌
    #But, 다른 파일로 보내주어야 할때는 다음과 같이 작성하면 내가 원하는 js파일로 보낼수 있다. 
    
    respond_to do |format|
      # 공백이나 space눌렀을때 정보나오지않게 하려고 설정
      if params[:q].strip.empty? 
        format.js {render 'no content'}
      else
        @movies= Movie.where("title LIKE ?", "#{params[:q]}%") #첫글자만 일치하고 뒤(%)는 아무거나
        format.js {render 'search_movie'}
      end

    # if params[:q].strip.empty? 
    #   render nothing: true # 아무 응답없음
    # end
    # @movies = Movie.where("title LIKE ?", "#{params[:q]}%") 
  end
...
```

* 원래는 액션을 만들면, 액션명과 일치하는 javascript파일을 찾아서 data를 보내준다.

* 여기서는 영화정보를 검색할때, 공백이나 space가 눌렸을때 아무런 정보도 검색되지 않게 설정하기 위해서 

  `params[:q].strip.empty? `일 경우 다른 곳으로 rendering 시켜야 한다. 

* 따라서 `respond_to do |format|`을 추가해서 우리가 원하는 파일로 render 시킬수 있게 된다.



*views/movies/search_movie.js.erb* 파일을 만든다.

* *views/movies/index.html.erb*에서 ` $('.recomm-movie').html('<a>${$(this).val()}</a>');` 을 삭제하고 

  `search_movie.js.erb`에서 작성한다.

```erb
console.log("찾음");
$('.recomm-movie').html(`
<% @movies.each do |movie| %>
<span class="badge badge-primary"><%= movie.title %></span>&nbsp;&nbsp; 
<% end %>
`); 
// 검색된 title이 모두 찍혀야한다. @movies는 배열형태이므로 반복문 사용
```

* `&nbsp;`는 공백을 의미한다.





## Pagination:  *kaminari*

> https://github.com/kaminari/kaminari

> https://github.com/KamilDzierbicki/bootstrap4-kaminari-views



*Gemfile.rb* 

```ruby
gem 'kaminari'
gem 'bootstrap4-kaminari-views'
```



*models/movie.rb*

```ruby
...
	paginates_per 8  # 한 페이지당 8개만 보여줌	
...
```

* page를 동작시키는 방법: 처음에 뽑아올때 몇개씩뽑아오는지 정하기



*app/views/movies/index.html.erb*

```erb
...
<%= paginate @movies, theme: 'twitter-bootstrap-4' %>   # 추가
...
```



*app/controllers/movies_controller.rb*

```ruby
  def index
    @movies = Movie.page(params[:page]) 
  end
...
```

