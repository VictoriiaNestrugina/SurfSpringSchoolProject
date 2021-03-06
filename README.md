# Классификатор изображений

## Обзор
С помощью open-source MobileNet CoreML модели приложение классифицирует изображение, используя 1000 категорий.
Изображение берется с камеры телефона, его памяти или с Unsplash.
  
<img src="/Demo/classifyFromDevice.gif" alt="drawing" width="200"/>   <img src="/Demo/classifyFromUnsplash.gif" alt="drawing" width="200"/>   <img src="/Demo/deletingCells.gif" alt="drawing" width="200"/>   <img src="/Demo/historySearch.gif" alt="drawing" width="200"/>

## Требования
### Обязательные фичи
1. Скачивание случайной картинки и ее классификация.
2. Статистика полученных изображений.

### Дополнительные фичи
Предоставить пользователю возможность делать фотографии через приложение.

### Фичи, отсутствующие в требованиях, но добавленные по собственной инициативе
1. Поиск по классифицированным картинкам.
2. Классификация картинки, загруженной из памяти телефона.
3. Выбор картинки с Unsplash и ее классификация.

## Комментарии к запуску
* Кнопка камеры в симуляторе неактивна
* В Unsplash ограничение в 50 запросов в час. При исчерпании выскочит ошибка "No Internet connection" (как и при отсутствии интернета). Это можно проверитить – заменить accessKey в enum NetworkConstants.

## Acknowledgments
* В интерфейсе использованы изображения с [Undraw](https://undraw.co)
