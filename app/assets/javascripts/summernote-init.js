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
    success: function(data) {    //ajax가 정상으로 실행되었을때, data를 받아서 동작
      console.log('file uploading...');
      console.log(data);
      return toSummernote.summernote("insertImage", data.image_path.url); // 수정
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