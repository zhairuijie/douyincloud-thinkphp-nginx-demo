<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\facade\Route;

Route::get('/api/hello', 'index/sayHello');
Route::post('/api/set_name', 'index/setName');
Route::get('/api/https', 'index/https');
Route::get('/api/http', 'index/http');
Route::get('/api/bzip2', 'index/bzip2');
Route::get('/api/dba', 'index/dba');
Route::get('/api/exif', 'index/exif');
Route::get('/api/bzip2', 'index/bzip2');
Route::get('/api/bzip2', 'index/bzip2');

