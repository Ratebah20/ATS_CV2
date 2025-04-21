from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, FileField, SubmitField
from wtforms.validators import DataRequired, Email, Length, ValidationError
from flask_wtf.file import FileRequired, FileAllowed

class ApplicationForm(FlaskForm):
    first_name = StringField('Prénom', validators=[DataRequired(), Length(max=50)])
    last_name = StringField('Nom', validators=[DataRequired(), Length(max=50)])
    email = StringField('Email', validators=[DataRequired(), Email(), Length(max=100)])
    phone = StringField('Téléphone', validators=[Length(max=20)])
    cover_letter = TextAreaField('Lettre de motivation')
    cv = FileField('CV (PDF uniquement)', validators=[
        FileRequired(),
        FileAllowed(['pdf'], 'Les CV doivent être au format PDF.')
    ])
    submit = SubmitField('Postuler')
    
    def validate_cv(self, field):
        if field.data:
            filename = field.data.filename
            if not filename.lower().endswith('.pdf'):
                raise ValidationError('Le fichier doit être au format PDF.')
