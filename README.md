#install and run instructions


تهيئة الويب كونكت في السرفر :
1- سحب نسخة من الرابط https://github.com/fork-foxs/wppconnect-server.git  البرانش wppconnect-morgim
2- التعديل في المتغيرات التالية :
        1-wppconnect-project-name/.env, port=21473  تغيير البورت الى نطاق مقارب بعد فحص ان البوت غير مستخدم
        2-wppconnect-project-name/config.ts , 
 secretKey: 'THISISMYSECURETOKEN', هنا القيمة تكون ثابتة وهي خاصة بكملة السر في الوب كوننكت
 EMAIL: 'admin@admin.com',  هنا الايميل الخاص بالبوت برس 
 PASSWORD: 'AdminFin@2024', هنا كلمة السر الخاصة بالبوت برس 
 BOT_URL: 'http://localhost:3000', // هنا يجب ادخال الرابط الخاص بالبوت برس مثل http://localhost:3000
 BOT_ID: 'jawali-business-bot',      هنا اسم البوت او الرقم التعريفي للبوت في البوت برس 
        3- wppconnect-project-name/src/config.ts, 
 secretKey: 'THISISMYSECURETOKEN', هنا القيمة تكون ثابتة وهي خاصة بكملة السر في الوب كوننكت
 EMAIL: 'admin@admin.com',  هنا الايميل الخاص بالبوت برس 
 PASSWORD: 'AdminFin@2024', هنا كلمة السر الخاصة بالبوت برس 
 BOT_URL: 'http://localhost:3000', // هنا يجب ادخال الرابط الخاص بالبوت برس مثل http://localhost:3000
 BOT_ID: 'jawali-business-bot',      هنا اسم البوت او الرقم التعريفي للبوت في البوت برس 
 port: '21473', //  هنا ادخال البورت الخاص بالوب كوننكت ويكون نفس البورت المدخل في ملف .env
3- تشغيل وبناء صورة الويب كوننكت :
docker compose --build -d 
4- إنشاء جلسة وربطها بالوتس من الواجهة 
url : http://<هنا رابط السرفر>:<هنا البورت>/api-docs/
session : 
mobile_nu : 
