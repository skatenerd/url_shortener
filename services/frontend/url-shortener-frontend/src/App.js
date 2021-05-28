import React from 'react';
import './App.css';
import { getSlug } from './api';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  handleSubmit = async (e) => {
    e.preventDefault()
    this.setState({errorMessage: null})
    const response = await getSlug(this.state.destination)
    if(response.ok) {
      this.setState({returnedSlug: response.headers.get("Content-Location")})
    } else {
      const errorMessage = await response.text()
      this.setState({errorMessage: errorMessage})
    }

  }

  render() {
    return (
      <div>
        <div className='instructions'>
          <span>Please Enter the desired URL</span>
        </div>
        {this.state.errorMessage &&
          <span>{this.state.errorMessage}</span>
        }
        <a href={this.state.returnedSlug}>{this.state.returnedSlug}</a>

        <div className='form_wrapper'>
          <form onSubmit={this.handleSubmit}>
            <input
              type='text'
              name='target_url'
              onChange={e => this.setState({destination: e.target.value})}
            />
            <button type="submit">Submit</button>
          </form>
        </div>
      </div>
    );
  }
}

export default App;
