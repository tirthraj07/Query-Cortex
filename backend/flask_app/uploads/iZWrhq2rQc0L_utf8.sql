ÿþ- -  
 - -   P o s t g r e S Q L   d a t a b a s e   d u m p  
 - -  
  
 - -   D u m p e d   f r o m   d a t a b a s e   v e r s i o n   1 6 . 3  
 - -   D u m p e d   b y   p g _ d u m p   v e r s i o n   1 6 . 3  
  
 S E T   s t a t e m e n t _ t i m e o u t   =   0 ;  
 S E T   l o c k _ t i m e o u t   =   0 ;  
 S E T   i d l e _ i n _ t r a n s a c t i o n _ s e s s i o n _ t i m e o u t   =   0 ;  
 S E T   c l i e n t _ e n c o d i n g   =   ' U T F 8 ' ;  
 S E T   s t a n d a r d _ c o n f o r m i n g _ s t r i n g s   =   o n ;  
 S E L E C T   p g _ c a t a l o g . s e t _ c o n f i g ( ' s e a r c h _ p a t h ' ,   ' ' ,   f a l s e ) ;  
 S E T   c h e c k _ f u n c t i o n _ b o d i e s   =   f a l s e ;  
 S E T   x m l o p t i o n   =   c o n t e n t ;  
 S E T   c l i e n t _ m i n _ m e s s a g e s   =   w a r n i n g ;  
 S E T   r o w _ s e c u r i t y   =   o f f ;  
  
 S E T   d e f a u l t _ t a b l e s p a c e   =   ' ' ;  
  
 S E T   d e f a u l t _ t a b l e _ a c c e s s _ m e t h o d   =   h e a p ;  
  
 - -  
 - -   N a m e :   s a l a r y ;   T y p e :   T A B L E ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 C R E A T E   T A B L E   p u b l i c . s a l a r y   (  
         u s e r _ i d   i n t e g e r   N O T   N U L L ,  
         s a l a r y   i n t e g e r  
 ) ;  
  
  
 A L T E R   T A B L E   p u b l i c . s a l a r y   O W N E R   T O   p o s t g r e s ;  
  
 - -  
 - -   N a m e :   u s e r s ;   T y p e :   T A B L E ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 C R E A T E   T A B L E   p u b l i c . u s e r s   (  
         u s e r _ i d   i n t e g e r   N O T   N U L L ,  
         u s e r _ n a m e   c h a r a c t e r   v a r y i n g ( 5 0 )   N O T   N U L L ,  
         u s e r _ e m a i l   c h a r a c t e r   v a r y i n g ( 5 0 )   N O T   N U L L ,  
         u s e r _ p a s s w o r d   c h a r a c t e r   v a r y i n g ( 5 0 )   N O T   N U L L  
 ) ;  
  
  
 A L T E R   T A B L E   p u b l i c . u s e r s   O W N E R   T O   p o s t g r e s ;  
  
 - -  
 - -   N a m e :   u s e r s _ u s e r _ i d _ s e q ;   T y p e :   S E Q U E N C E ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 C R E A T E   S E Q U E N C E   p u b l i c . u s e r s _ u s e r _ i d _ s e q  
         A S   i n t e g e r  
         S T A R T   W I T H   1  
         I N C R E M E N T   B Y   1  
         N O   M I N V A L U E  
         N O   M A X V A L U E  
         C A C H E   1 ;  
  
  
 A L T E R   S E Q U E N C E   p u b l i c . u s e r s _ u s e r _ i d _ s e q   O W N E R   T O   p o s t g r e s ;  
  
 - -  
 - -   N a m e :   u s e r s _ u s e r _ i d _ s e q ;   T y p e :   S E Q U E N C E   O W N E D   B Y ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 A L T E R   S E Q U E N C E   p u b l i c . u s e r s _ u s e r _ i d _ s e q   O W N E D   B Y   p u b l i c . u s e r s . u s e r _ i d ;  
  
  
 - -  
 - -   N a m e :   u s e r s   u s e r _ i d ;   T y p e :   D E F A U L T ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 A L T E R   T A B L E   O N L Y   p u b l i c . u s e r s   A L T E R   C O L U M N   u s e r _ i d   S E T   D E F A U L T   n e x t v a l ( ' p u b l i c . u s e r s _ u s e r _ i d _ s e q ' : : r e g c l a s s ) ;  
  
  
 - -  
 - -   D a t a   f o r   N a m e :   s a l a r y ;   T y p e :   T A B L E   D A T A ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 C O P Y   p u b l i c . s a l a r y   ( u s e r _ i d ,   s a l a r y )   F R O M   s t d i n ;  
 1 	 1 1 3 4 7  
 2 	 1 6 1 7 3  
 3 	 2 0 7 3 0  
 4 	 1 0 5 3 7  
 5 	 2 7 9 4 0  
 6 	 1 1 8 3 9  
 7 	 2 3 4 8 5  
 8 	 2 2 1 4 9  
 9 	 1 7 8 9 5  
 1 0 	 1 1 9 7 4  
 \ .  
  
  
 - -  
 - -   D a t a   f o r   N a m e :   u s e r s ;   T y p e :   T A B L E   D A T A ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 C O P Y   p u b l i c . u s e r s   ( u s e r _ i d ,   u s e r _ n a m e ,   u s e r _ e m a i l ,   u s e r _ p a s s w o r d )   F R O M   s t d i n ;  
 1 	 J o h n D o e 	 j o h n d o e @ e x a m p l e . c o m 	 p a s s w o r d 1 2 3  
 2 	 J a n e S m i t h 	 j a n e s m i t h @ e x a m p l e . c o m 	 p a s s w o r d 4 5 6  
 3 	 M i k e J o h n s o n 	 m i k e j o h n s o n @ e x a m p l e . c o m 	 p a s s 7 8 9 w o r d  
 4 	 E m i l y D a v i s 	 e m i l y d a v i s @ e x a m p l e . c o m 	 m y P a s s w o r d !  
 5 	 R o b e r t B r o w n 	 r o b e r t b r o w n @ e x a m p l e . c o m 	 s e c u r e P a s s 1 2 3  
 6 	 L i n d a W i l s o n 	 l i n d a w i l s o n @ e x a m p l e . c o m 	 1 2 3 s t r o n g P A S S  
 7 	 D a v i d M a r t i n e z 	 d a v i d m a r t i n e z @ e x a m p l e . c o m 	 p w S e c u r e !  
 8 	 J e n n i f e r L e e 	 j e n n i f e r l e e @ e x a m p l e . c o m 	 l e e P a s s w o r d 2 0 2 1  
 9 	 M i c h a e l G a r c i a 	 m i c h a e l g a r c i a @ e x a m p l e . c o m 	 g a r c i a P a s s 0 9 8  
 1 0 	 S a r a h C l a r k 	 s a r a h c l a r k @ e x a m p l e . c o m 	 p a s s 4 S a r a h !  
 \ .  
  
  
 - -  
 - -   N a m e :   u s e r s _ u s e r _ i d _ s e q ;   T y p e :   S E Q U E N C E   S E T ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 S E L E C T   p g _ c a t a l o g . s e t v a l ( ' p u b l i c . u s e r s _ u s e r _ i d _ s e q ' ,   1 0 ,   t r u e ) ;  
  
  
 - -  
 - -   N a m e :   s a l a r y   s a l a r y _ p k e y ;   T y p e :   C O N S T R A I N T ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 A L T E R   T A B L E   O N L Y   p u b l i c . s a l a r y  
         A D D   C O N S T R A I N T   s a l a r y _ p k e y   P R I M A R Y   K E Y   ( u s e r _ i d ) ;  
  
  
 - -  
 - -   N a m e :   u s e r s   u s e r s _ p k e y ;   T y p e :   C O N S T R A I N T ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 A L T E R   T A B L E   O N L Y   p u b l i c . u s e r s  
         A D D   C O N S T R A I N T   u s e r s _ p k e y   P R I M A R Y   K E Y   ( u s e r _ i d ) ;  
  
  
 - -  
 - -   N a m e :   u s e r s   u s e r s _ u s e r _ e m a i l _ k e y ;   T y p e :   C O N S T R A I N T ;   S c h e m a :   p u b l i c ;   O w n e r :   p o s t g r e s  
 - -  
  
 A L T E R   T A B L E   O N L Y   p u b l i c . u s e r s  
         A D D   C O N S T R A I N T   u s e r s _ u s e r _ e m a i l _ k e y   U N I Q U E   ( u s e r _ e m a i l ) ;  
  
  
 - -  
 - -   P o s t g r e S Q L   d a t a b a s e   d u m p   c o m p l e t e  
 - -  
  
 