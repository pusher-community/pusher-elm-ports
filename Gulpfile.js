var gulp = require('gulp');
var liveServer = require('live-server');
var $ = require('gulp-load-plugins')({});

gulp.task('build', function() {
  return gulp.src([
    'App.elm',
  ]).pipe($.plumber())
    .pipe($.elm())
    .pipe(gulp.dest('build/'));
});

gulp.task('start', ['build'], function() {
  gulp.watch('**/*.elm', ['build']);
});

gulp.task('serve', function() {
  liveServer.start();
});
