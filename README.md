ResNet50 implementation using TensorFlow-2.0 to the task of glaucoma detection

## Train
1. Requirements:
+ Python >= 3.6
+ Tensorflow == 2.0.0
2. Put the dataset under the folder **original dataset**, and the directory should look like this:
```
|——original dataset
   |——class_name_0
   |——class_name_1
   |——class_name_2
   |——class_name_3
```
3. Run the script **split_dataset.py** to split the raw dataset into train set, valid set and test set.
4. Change the corresponding parameters in **config.py**.
5. Run **train.py** to start training.
## Evaluate
Run **evaluate.py** to evaluate the model's performance on the test dataset.
