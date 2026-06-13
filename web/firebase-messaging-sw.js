importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyAjmpH2kJT3QztJ_CG1xrMwWznlJaaDGxo",
  authDomain: "taafi-hand-recovery.firebaseapp.com",
  projectId: "taafi-hand-recovery",
  storageBucket: "taafi-hand-recovery.firebasestorage.app",
  messagingSenderId: "666637158846",
  appId: "1:666637158846:web:010292d89db9811b2491ef"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const { title, body } = payload.notification;
  self.registration.showNotification(title, {
    body: body,
    icon: '/icons/Icon-192.png'
  });
});
