# 4차산업혁명 선도인재 양성 프로젝트 과정

---
## 1. Week 1 Day 17:   

***



### Ajax



gem 'devise'

gem 'faker'

gem 'kaminari'

gem 'bootstrap-sass'



rails g devise:install

rails g scaffold posts title contents:text

 rails g devise user

rails g model comment post:references body:text

rake db:migrate



posts가 먼저 만들어줘야 foreign_key가 true가 refernces가 정상적으로 작동



/app/assets/stylesheets/application.scss로 변경

내용 다 지우고 @import 'bootstrap';



routes.rb => rake routes 통해 확인

```ruby
member do
  post '/create_comment' => 'posts#create_comment', as: 'create_comment_to' 
  #create_comment액션으로
  end
end
```



##### form jquery event

https://api.jquery.com/category/events/form-events/



#### preventDefault()

form에 작성버튼 클릭시 form 안에 내용이 

/posts/1/create_comment이 

posts#create_comment



##### Q. 댓글달기 + ajax로 구현

1. form 태그 안에 input 태그에 값(댓글내용)을 만들기
2. submit 버튼을 클린한다. (submit 이벤트 발생)

1-1. input태그에 있는 값을 가져온다.

1-2. 값이 유효한지 확인한다. (빈칸인지 아닌지)

1-3. 값이 없으면 값을 넣으라는 안내메시지를 뿌린다.

3. ajax로 처리한다

3-1. 현재 글이 어딘지, 작성자는 누군지 파악한다.

3-2. db에 댓글을 저장한다

3. 서버에서 처리가 완료되면 화면에 댓글을 출력한다.
4. 댓글이 등록됐다고 알림주기
5. 페이지 refresh 없이 댓글 이어주기



#### ajax 

url, method, data입력 필요

```ruby
<%= form_tag create_comment_to_post_path, id: "comment" do %>
  <%= text_field_tag :body %>
  <%= submit_tag "댓글달기" %>
<% end %>
```



##### 모든 댓글이 출력

```ruby
  <tbody>
    <% @post.comments.reverse.each do |p| %>
    <tr>
      <td><%= p.body %></td>
    </tr>
    <% end %>
  </tbody>
```



create_comment.js.erb

javascript로 생성



before_action에 :create_comment 추가

```ruby
alert("댓글등록완료");
$('#body').val("");
$('#comment_table tbody').prepend('<tr><td><%= @c.body %></td></tr>');
```



please_login.js.erb

```ruby
if(confirm("로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?"))
{
    location.href="<%= new_user_session_path %>";
}
```



##### show.erb

##### alert

```ruby
<script>
  $(function() {
    var form = $('#comment');
    form.on('submit', function(e) { //parameter에 매개변수 event e 
      e.preventDefault(); //method 실행
      //console.log("haha"); form 클릭시 haha 출력, 이벤트 바인딩 완료
      var contents = $('#body').val(); // id = body에 value롤 가지고온다.
      console.log(contents);
      $.ajax({
        url: "<%= create_comment_to_post_path %>",
        method: "POST",
        //url + method
        data: {body: contents} // value = contents
      });
    });
  })
</script>
```

