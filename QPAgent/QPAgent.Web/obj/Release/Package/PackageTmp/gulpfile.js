var gulp = require('gulp'),
    minify = require('gulp-minify'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    bom = require('gulp-bom'),
    inject = require('gulp-inject'),
    order = require('gulp-order'),
    rename = require('gulp-rename'),
    eventstream = require('event-stream'),
    del = require('del');

var guid = require('./Guid')();

gulp.task('clean', function () {
    del(['./build/app/*.js',
        './build/app/*.css',
        './build/login/*.js',
        './build/login/*.css'
    ]);
});

gulp.task('vendor', function () {
    gulp.src('./src/vendor/avalon2/*.css')
        .pipe(gulp.dest('build/vendor/avalon'));

    gulp.src('./src/vendor/avalon2/*.js')
        .pipe(gulp.dest('build/vendor/avalon'));

    gulp.src('./src/vendor/jquery/*.css')
    .pipe(gulp.dest('build/vendor/jquery'));

    gulp.src('./src/vendor/jquery/jquery-1.10.2.min.js')
    .pipe(rename('jquery.js'))
    .pipe(gulp.dest('build/vendor/jquery'));

    gulp.src('./src/vendor/jquery/extend/*.js')
        .pipe(concat('jquery-extend.js'))
        .pipe(uglify())
        .pipe(gulp.dest('build/vendor/jquery'));
});

gulp.task('login', function () {
    var loginjs = gulp.src('./src/login/*.js')
        .pipe(order([
            'MessageState.js',
            'ValidateState.js',
            '*.js'
        ]))
        .pipe(concat('login' + guid + '.js'))
        .pipe(uglify())
        .pipe(gulp.dest('build/login'));

    var logincss = gulp.src('./src/login/*.css')
        .pipe(concat('login' + guid + '.css'))
        .pipe(gulp.dest('build/login'));

    gulp.src('./views/Login0.aspx')
        .pipe(bom())
        .pipe(inject(eventstream.merge(loginjs, logincss)))
        .pipe(rename('Login.aspx'))
        .pipe(gulp.dest('./'));
});

gulp.task('app', function () {
    var appjs = gulp.src('./src/app/**/*.js')
        .pipe(order([
            'common/*.js',
            'components/*.js',
            'vmodels/*.js',
            'js/app.init.js',
            'js/app.js',
            'js/vm.init.js'
        ]))
        .pipe(concat('app' + guid + '.js'))
        .pipe(gulp.dest('build/app'));

    var appcss = gulp.src('./src/app/**/*.css')
        .pipe(order([
            'css/styles.css',
            '**/*.css'
        ]))
        .pipe(concat('app' + guid + '.css'))
        .pipe(gulp.dest('build/app'));

    gulp.src('./views/Default0.aspx')
        .pipe(bom())
        .pipe(inject(eventstream.merge(appjs, appcss)))
        .pipe(rename('Default.aspx'))
        .pipe(gulp.dest('./'));
});

//gulp.task('default', ['vendor']);
gulp.task('default', ['clean', 'vendor', 'login', 'app']);
