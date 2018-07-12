# 20180712_WYSIWYG Editor



## summernote

> https://summernote.org/
>
> summernote 페이지 [https://github.com/summernote/summernote-rails]



*Gemfile*

```ruby
# wysiwyg editor
gem 'summernote-rails', '~> 0.8.10.0'
```



*app/assets/stylesheets/application.scss*

```scss
@import "bootstrap";
@import "summernote-bs4";
```



*app/assets/javascripts/application.js*   : 추가

```javascript
//= require summernote/summernote-bs4.min   
```



> **.coffee 를 .js 파일로 변환**
>
> http://js2.coffee/



*app/assets/javascripts/summernote-init.js*  : 파일 생성 & 내용 넣기

```javascript
$(document).on('ready', function() {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      height: 300
    });
  });
});
```



*app/views/movies/_form.html.erb*

```erb
...
  <div class="form-group">
  <%= f.label :description %>
  <%= f.text_field :description , 'data-provider': :summernote %>   <!-- 수정 -->
  </div>
...
```



### 이미지 커스텀하기위한 추가

> https://github.com/summernote/summernote-rails/wiki/Image-File-Upload-to-Server

`.coffee ` -> `.js` 로 바꿔서 추가

*app/assets/javascripts/summernote-init.js*

```javascript
$(document).on('ready', function() {
  function sendFile(file, toSummernote) {
  var data = new FormData;
  data.append('upload[image]', file);
  $.ajax({
    data: data,
    type: 'POST',
    url: '/uploads',
    cache: false,
    contentType: false,
    processData: false,
    success: function(data) {   //ajax가 정상으로 실행되었을때, data를 받아서 동작
      console.log('file uploading...');
      console.log(data);
      return toSummernote.summernote("insertImage", data.image_path.url);  //수정
    }
  });
};
    
  $('[data-provider="summernote"]').each(function() {
     $(this).summernote({
      height: 300,
      callbacks: {    // 이미지 upload하면 callback들을 커스텀해서 보내줌
        onImageUpload: function(files) {
          return sendFile(files[0], $(this));
        }
      }
    });
  });
});
```



**모델 생성** : 다른 모델과 관계가 없고 이미지들만 저장해놓는다.

`$ rails g model images image_path` 

`$ rails g uploader summernote`



*app/models/image.rb*

```ruby
class Image < ApplicationRecord
    mount_uploader :image_path, SummernoteUploader
end
```



*routes.rb*

`  post '/uploads' => 'movies#upload_image'`  추가



*app/controllers/movies_controller.rb*

```ruby
...
  def upload_image
    @image = Image.create(image_path: params[:upload][:image])  # hash 형태라서..
    render json: @image
  end
...
```

-> 실행했을때 이미지가 나오지 않고 <p> ... </p> 가 나옴



*`views/movies/show.html.erb*

```erb
<h1><%= @movie.title %></h1>
<hr>
<p><%= simple_format(@movie.description) %></p> <!-- 브라우저가 인식할 수 있는 html tag로 바꿈 -->
<%= link_to 'Edit', edit_movie_path(@movie) %> |
<%= link_to 'Back', movies_path %>
<hr>
...
```







## RailsAdmin_관리자

> https://github.com/sferik/rails_admin



*Gemfile*

```ruby
# rails admin
gem 'rails_admin'
```



`$ rails g rails_admin:install `

