var gulp = require('gulp');
var watch = require('gulp-watch');
var elm = require('gulp-elm');

gulp.task('build', function() {
  return gulp.src('App.elm')
    .pipe(elm())
    .pipe(gulp.dest('build/'));
});

gulp.task('start', ['build'], function() {
  gulp.watch('App.elm', ['build']);
});
