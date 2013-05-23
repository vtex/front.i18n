# Locale Selector

O seletor front end de línguas.

Baixe o repositório e instale as dependências:

```console
npm i -g grunt-cli
npm i
grunt
```

Você poderá vê-lo em ação em `http://localhost:9001/`.

## Setup

Primeiramente carregue todas as [dependências](#dependncias) Javascript. Em seguida, carregue seus arquivos de translations. Você pode encontrar um exemplo do formato a ser seguido em `/src/coffee/translation-en-US.coffee`.

Agora é só inicar o plugin no evento de `$(document).ready()` do jQuery com a função `vtex.i18n.init()`.


Para traduzir um elemento na página, adicione o atributo `data-i18n` com o valor da chave do arquivo de translation. Por exemplo:

```html
<p data-i18n="chave"></p>
```
	
Caso queira traduzir um atributo do elemento HTML, como o atributo `title`, `alt` ou `placeholder`. Use o seguinte formato:

```html
<a data-i18n="[title]chave"></a>
```

Caso não queira ter um select para o usuário final trocar de língua, apenas não inclua o elemento com o id `#vtex-locale-selector`, tudo continuará a funcionar normalmente. Ou seja, você ainda poderá usar a API por Javascript.

## API

<h4 id="init"><code>vtex.i18n.init(locale)</code></h4>
<p>Inicia o plugin.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>locale</td>
			<td>string</td>
			<td><code>"pt-BR"</code> (opcional)</td>
			<td>Inicia com um locale específico.</td>
		</tr>
	</tbody>
</table>

<br>

<h4 id="setLocaleCallback"><code>vtex.i18n.setLocaleCallback(callback)</code></h4>
<p>Seta uma função de callback ao trocar a língua.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>callback</td>
			<td>function ou string</td>
			<td>função ou <code>"vtex.i18n.update"</code></td>
			<td>Caso seja do tipo <code>function</code>, o callback chamará a função passando como parametro o novo locale. Caso seja do tipo <code>string</code>, assume-se que será chamado um canal do Radio.<br> Ex: para o parametro do tipo string <code>vtex.i18n.update</code>, um possível callback a ser chamado seria: <code>radio('vtex.i18n.update').broadcast('pt-BR')</code></td>
		</tr>
	</tbody>
</table>

<br>

<h4 id="setLocale"><code>vtex.i18n.setLocale(locale)</code></h4>
<p>Troca a língua corrente.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>locale</td>
			<td>string</td>
			<td><code>"en-US"</code></td>
			<td>Locale da língua a ser usada.</td>
		</tr>
	</tbody>
</table>

<br>

<h4 id="setCountryCodeCallback"><code>vtex.i18n.setCountryCodeCallback(callback)</code></h4>
<p>Seta uma função de callback ao trocar o <code>countryCode</code>.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>callback</td>
			<td>function ou string</td>
			<td>função ou <code>"vtex.countryCode.update"</code></td>
			<td>Caso seja do tipo <code>function</code>, o callback chamará a função passando como parametro o novo <code>countryCode</code>. Caso seja do tipo <code>string</code>, assume-se que será chamado um canal do Radio.<br> Ex: para o parametro do tipo string <code>vtex.countryCode.update</code>, um possível callback a ser chamado seria: <code>radio('vtex.countryCode.update').broadcast('ARG')</code></td>
		</tr>
	</tbody>
</table>

<br>

<h4 id="setCountryCode"><code>vtex.i18n.setCountryCode(countryCode)</code></h4>
<p>Troca o countryCode a ser usado pela função <code>vtex.i18n.getCurrencySymbol</code></p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>countryCode</td>
			<td>string</td>
			<td><code>"USA"</code></td>
			<td><code>countryCode</code> do país.</td>
		</tr>
	</tbody>
</table>

<br>

<h4 id="getCurrencySymbol"><code>vtex.i18n.getCurrencySymbol(countryCode)</code></h4>
<p>Retorna o símbolo monetário do país.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>countryCode</td>
			<td>string</td>
			<td><code>"ARG"</code> (opcional)</td>
			<td>Tem como default o valor de <code>vtex.i18n.countryCode</code> ou pelo <code>countryCode</code> passado como parametro.</td>
		</tr>
	</tbody>
</table>

### Dependências

- [jQuery](http://jquery.com/)
- [Select2](http://ivaynberg.github.io/select2/)
- [i18next](http://i18next.com/)

Podendo ser extensível com a biblioteca de pub/sub [Radio.js](http://radio.uxder.com/).

-------

VTEX - 2013
