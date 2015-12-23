const gulp = require('gulp');
const ghPages = require('gulp-gh-pages');

gulp.task('deploy-flash', function() {
  return gulp.src(['./Export/flash/bin/**/*', './flash_test/**/*'])
    .pipe(ghPages());
});