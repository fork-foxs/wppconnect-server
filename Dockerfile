# --------------------------------------------------------------------------------
# STAGE 1: BUILDER
# الهدف: تثبيت كل التبعيات (بما فيها تبعيات التطوير) وتجميع كود TypeScript
# --------------------------------------------------------------------------------
FROM node:22-bullseye-slim AS builder

# 1. تثبيت تبعيات النظام الأساسية
# هذا الجزء ضروري لتجميع وحدات النظام الأصلية مثل sharp و bcrypt
# ولتوفير بيئة تشغيل Puppeteer (Chromium)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # أدوات البناء الأساسية لتجميع الوحدات الأصلية (bcrypt, sharp)
    build-essential \
    python3 \
    pkg-config \
    # مكتبة libvips وتبعياتها لـ sharp
    libvips-dev \
    libvips \
    # تبعيات وقت التشغيل والتجميع لـ Puppeteer (Chromium)
    libxshmfence-dev \
    libgbm-dev \
    fontconfig \
    locales \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    wget \
    # تنظيف cache APT
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ ملفات التبعيات
COPY package.json package-lock.json ./

# 2. تثبيت كل التبعيات (بما فيها devDependencies)
# *الحل لخطأ ERESOLVE والـ Husky*
# - --legacy-peer-deps: لحل ERESOLVE.
# - --ignore-scripts: لتجاوز سكريبت 'husky install' (prepare).
RUN npm install --legacy-peer-deps --ignore-scripts

# نسخ كود التطبيق المتبقي
COPY . .

# 3. تجميع TypeScript
# *الحل لخطأ MODULE_NOT_FOUND*
# هذا ينشئ ملفات .js في مجلد /dist
RUN npm run build

# --------------------------------------------------------------------------------
# STAGE 2: PRODUCTION
# الهدف: صورة نهائية صغيرة للإنتاج، تحتوي فقط على التبعيات ووقت التشغيل
# --------------------------------------------------------------------------------
FROM node:22-bullseye-slim AS production

WORKDIR /app

# 1. تثبيت تبعيات النظام اللازمة للتشغيل فقط (runtime)
# (libvips, libxshmfence1, libgbm1 هي اللازمة لـ sharp و puppeteer)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libvips \
    libxshmfence1 \
    libgbm1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. نسخ الملفات الضرورية فقط من مرحلة البناء
# هذا يضمن أن تكون صورة الإنتاج صغيرة وآمنة.
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json

# نسخ الملفات الأخرى غير المُجمَّعة (مثل الإعدادات والموارد)
# COPY --from=builder /app/config ./config
# COPY --from=builder /app/src/assets ./src/assets
# COPY --from=builder /app/src/controller/encryptController.js ./src/controller/encryptController.js
# ... (يمكن إضافة المزيد من المجلدات/الملفات اللازمة للتشغيل هنا)

# تعيين مستخدم غير جذري (ممارسات أمنية أفضل)
USER node

# كشف المنفذ الافتراضي
EXPOSE 21465

# أمر التشغيل النهائي
CMD [ "npm", "start" ]
