# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

genres = ["Horror", "Thriller", "Action", "Drama", "Comedy", "Romance", "SF", "Adventure"]
images = %w(http://www.tarts-korea.co.kr/uploaded/category/catalog_69ce0457ef13dc1f34b1a131d15d49210.jpg 
            http://notefolio.net/data/img/96/c4/96c41b1868ab060212a2c58e6360070b9a7aeb6067f771716730b85a7440303d_v1.jpg 
            https://i.pinimg.com/originals/50/f3/a6/50f3a6a91fa2bb295bb9d02d4ff0fda1.jpg 
            http://file.gamedonga.co.kr/files/2017/04/27/caba.jpg 
            http://thumbnail.egloos.net/600x0/http://pds17.egloos.com/pds/200912/07/64/c0073964_4b1bd4408061a.jpg
            https://t1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/oTW/image/1LkMoKvhe_Vvj_Y15MLHpymVnsg.jpg 
            http://www.obaltan.net/bbs/data/poster/jung1.jpg 
            https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTltcaGAAF9_Pxe38nUKtigSLAkzdXYlWc9BeTfJpjACL_guhmvKQ 
            https://t1.daumcdn.net/cfile/tistory/02670949519B05CA2F 
            http://img.sbs.co.kr/newimg/news/20150822/200862111.jpg 
            http://cbmtoronto.com/files/attach/images/28274/310/073/f0e8a581535d915d563707bd2e407803.jpg 
            https://i.ytimg.com/vi/l88NDPKG5M4/hqdefault.jpg 
            http://www.topstarnews.net/news/photo/first/201608/img_207302_1.jpg 
            http://pds10.egloos.com/pds/200902/18/45/a0112945_499b1aaf5de99.jpg 
            https://t1.daumcdn.net/cfile/tistory/162E0E3B4D7D9CD12D 
            http://cfile24.uf.tistory.com/image/2316973E50CB37362A7215  
            http://www.travelibrary.org/data/editor/1805/thumb-4c5fd9077ea977f30dda301b017f312d_1525747628_0978_600x338.jpg  
            https://1.bp.blogspot.com/-9OftNc9VnUw/VGVcOM-n5fI/AAAAAAAACJ8/mi_IVCGUJLc/s1600/b0013665_545da9d458c31.jpg 
            https://upload.wikimedia.org/wikipedia/ko/b/bc/%EC%84%BC%EA%B3%BC_%EC%B9%98%ED%9E%88%EB%A1%9C%EC%9D%98_%ED%96%89%EB%B0%A9%EB%B6%88%EB%AA%85_%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg )
            
User.create(email: "bb@b.b", password: "123123", password_confirmation: "123123")
# 배열만들때 %w 를 써서 space로 구분가능
30.times do
movie = Movie.create(title: Faker::Space.star,
                      genre: genres.sample,
                      director: Faker::FunnyName.name_with_initial,
                      actor: Faker::Name.name,  
                      description: Faker::Lorem.paragraph,
                      remote_image_path_url: images.sample,
                      user_id: 1)
end