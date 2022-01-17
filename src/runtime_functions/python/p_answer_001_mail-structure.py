# Basic function libraries
import numpy as np

# Evaluating the politeness of a provided mail text
def p_answer_001_mail_politeness (mail_text):

    # The below model import model was fine-tuned using the following checkpoint from the huggingface library
    #checkpoint = "deepset/gbert-base"
    # Since at production time Internet will not be accessible, the Tokenizer and Model are downloaded locally.

    # Getting the tokenizer for the defined model
    from transformers import AutoTokenizer
    #tokenizer = AutoTokenizer.from_pretrained(checkpoint)
    #tokenizer.save_pretrained("src/runtime_functions/python/hf_tokenizer_deepset-gbert-base")
    tokenizer = AutoTokenizer.from_pretrained("runtime_functions/python/hf_tokenizer_deepset-gbert-base")

    # Getting the encodings (as tensors for tensorflow) for the texts for training, validation, and testing
    text_encodings = dict(tokenizer(mail_text, padding=True, truncation=True, return_tensors='np'))

    # Loading the model architecture and the pretrained weights
    from transformers import TFAutoModelForSequenceClassification
    model = TFAutoModelForSequenceClassification.from_pretrained("runtime_functions/python/hf_model_a4s_i2b.tf")

    # Calculation of the probabilities for each class
    # There is no softmax layer at the top of the models in Hugging Face, therefore
    # the probabilities have to be calculated here using the softmax function
    import tensorflow as tf
    text_pred_prob = tf.nn.softmax(model.predict(dict(text_encodings))['logits'])

    # Extraction of the class number with the highest probability
    text_pred_class = np.argmax(text_pred_prob, axis=1)

    answer = {
        "score": text_pred_class[0],
        "variant": 0,
        "prob": tf.get_static_value(text_pred_prob[0,text_pred_class[0]])
    }
    return(answer)
